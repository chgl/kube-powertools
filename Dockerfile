# kics-scan disable=b03a748a-542d-44f4-bb86-9199ab4fd2d5
FROM docker.io/library/ubuntu:24.04@sha256:66460d557b25769b102175144d538d88219c077c678a49af4afca6fbfc1b5252
SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
ENV NO_UPDATE_NOTIFIER=true \
    NODE_ENV=production \
    PATH="$PATH:/root/node_modules/.bin"
WORKDIR /root

# hadolint ignore=DL3008,SC1091
RUN <<EOF
apt-get update
DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y --no-install-recommends \
    python3-pip git curl jq s3cmd nodejs npm ca-certificates
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y --no-install-recommends \
    docker-ce-cli
apt-get clean
rm -rf /var/lib/apt/lists/*
EOF

COPY requirements.txt package*.json ./

# break-system-packages should be fine in a container environment
RUN <<EOF
pip install --no-cache-dir --require-hashes --break-system-packages -r requirements.txt
npm clean-install
EOF

# kubectl
COPY --from=docker.io/rancher/kubectl:v1.34.1@sha256:090bef429ed1bdb10ebd4e82ac6b1b4695276e3a15cfeef6fa2772daed6deb89 /bin/kubectl /usr/bin/kubectl
RUN kubectl version --client

# Helm
# renovate: datasource=github-releases depName=helm/helm
ARG HELM_VERSION=3.19.0
ENV HELM_URL=https://get.helm.sh/helm-v"${HELM_VERSION}"-linux-amd64.tar.gz
RUN <<EOF
curl -LSs "$HELM_URL" | tar xz
mv linux-amd64/helm /usr/local/bin/helm
chmod +x /usr/local/bin/helm
helm version
EOF

# Helm push plugin
# renovate: datasource=github-releases depName=chartmuseum/helm-push
ARG HELM_PUSH_PLUGIN_VERSION=0.10.4
RUN <<EOF
helm plugin install --version=v${HELM_PUSH_PLUGIN_VERSION} https://github.com/chartmuseum/helm-push
helm cm-push --help
EOF

# Helm Local Chart Version Plugin
# renovate: datasource=github-releases depName=mbenabda/helm-local-chart-version
ARG HELM_LOCAL_CHART_VERSION_PLUGIN_VERSION=0.1.0
RUN <<EOF
helm plugin install --version=v${HELM_LOCAL_CHART_VERSION_PLUGIN_VERSION} https://github.com/mbenabda/helm-local-chart-version
helm local-chart-version version
EOF

# Helm schema plugin
# renovate: datasource=github-releases depName=dadav/helm-schema
ARG HELM_SCHEMA_GEN_PLUGIN_VERSION=0.16.1
RUN <<EOF
helm plugin install --version=v${HELM_SCHEMA_GEN_PLUGIN_VERSION} https://github.com/dadav/helm-schema
helm schema --help
EOF

# Helm unittest plugin
# renovate: datasource=github-releases depName=helm-unittest/helm-unittest
ARG HELM_UNITTEST_PLUGIN_VERSION=1.0.3
RUN <<EOF
helm plugin install --version=v${HELM_UNITTEST_PLUGIN_VERSION} https://github.com/helm-unittest/helm-unittest
helm unittest --help
EOF

# Chart Doc Gen
# renovate: datasource=github-releases depName=kubepack/chart-doc-gen
ARG CHART_DOC_GEN_VERSION=0.5.0
ENV CHART_DOC_GEN_URL=https://github.com/kubepack/chart-doc-gen/releases/download/v"${CHART_DOC_GEN_VERSION}"/chart-doc-gen-linux-amd64
RUN <<EOF
curl -LSsO "$CHART_DOC_GEN_URL"
mv chart-doc-gen-linux-amd64 /usr/local/bin/chart-doc-gen
chmod +x /usr/local/bin/chart-doc-gen
EOF

# Helm Docs
# renovate: datasource=github-releases depName=norwoodj/helm-docs
ARG HELM_DOCS_VERSION=1.14.2
ENV HELM_DOCS_URL=https://github.com/norwoodj/helm-docs/releases/download/v${HELM_DOCS_VERSION}/helm-docs_${HELM_DOCS_VERSION}_Linux_x86_64.tar.gz
RUN <<EOF
curl -LSs "$HELM_DOCS_URL" | tar xz
mv ./helm-docs /usr/local/bin/helm-docs
chmod +x /usr/local/bin/helm-docs
helm-docs --version
EOF

# Kubeval
# renovate: datasource=github-releases depName=instrumenta/kubeval
ARG KUBEVAL_VERSION=v0.16.1
ENV KUBEVAL_URL=https://github.com/instrumenta/kubeval/releases/download/${KUBEVAL_VERSION}/kubeval-linux-amd64.tar.gz
RUN <<EOF
curl -LSs "$KUBEVAL_URL" | tar xz
mv ./kubeval /usr/local/bin/kubeval
chmod +x /usr/local/bin/kubeval
kubeval --version
EOF

# Kubeconform
# renovate: datasource=github-releases depName=yannh/kubeconform
ARG KUBECONFORM_VERSION=0.7.0
ENV KUBECONFORM_URL=https://github.com/yannh/kubeconform/releases/download/v${KUBECONFORM_VERSION}/kubeconform-linux-amd64.tar.gz
RUN <<EOF
curl -LSs "$KUBECONFORM_URL"| tar xz
mv ./kubeconform /usr/local/bin/kubeconform
chmod +x /usr/local/bin/kubeconform
kubeconform -h
EOF

# Kube Score
# renovate: datasource=github-releases depName=zegl/kube-score
ARG KUBE_SCORE_VERSION=1.20.0
ENV KUBE_SCORE_URL=https://github.com/zegl/kube-score/releases/download/v${KUBE_SCORE_VERSION}/kube-score_${KUBE_SCORE_VERSION}_linux_amd64
RUN <<EOF
curl -LSs "$KUBE_SCORE_URL" -o kube-score
mv kube-score /usr/local/bin/kube-score
chmod +x /usr/local/bin/kube-score
kube-score version
EOF

# Chart Testing
# renovate: datasource=github-releases depName=helm/chart-testing
ARG CT_VERSION=3.14.0
ENV CT_URL=https://github.com/helm/chart-testing/releases/download/v"${CT_VERSION}"/chart-testing_"${CT_VERSION}"_linux_amd64.tar.gz
RUN <<EOF
curl -LSs "$CT_URL" | tar xz
mv ./ct  /usr/local/bin/ct
chmod +x /usr/local/bin/ct
ct version
EOF

# Fairwinds Polaris
# renovate: datasource=github-releases depName=FairwindsOps/polaris
ARG POLARIS_VERSION=10.1.1
ENV POLARIS_URL=https://github.com/FairwindsOps/polaris/releases/download/${POLARIS_VERSION}/polaris_linux_amd64.tar.gz
RUN <<EOF
curl -LSs "$POLARIS_URL" | tar xz
mv ./polaris  /usr/local/bin/polaris
chmod +x /usr/local/bin/polaris
polaris version
EOF

# Fairwinds Pluto
# renovate: datasource=github-releases depName=FairwindsOps/pluto
ARG PLUTO_VERSION=5.22.5
ENV PLUTO_URL=https://github.com/FairwindsOps/pluto/releases/download/v${PLUTO_VERSION}/pluto_${PLUTO_VERSION}_linux_amd64.tar.gz
RUN <<EOF
curl -LSs "$PLUTO_URL" | tar xz
mv ./pluto /usr/local/bin/pluto
chmod +x /usr/local/bin/pluto
pluto version
EOF

# Stackrox Kube Linter
# renovate: datasource=github-releases depName=stackrox/kube-linter
ARG KUBE_LINTER_VERSION=v0.7.6
ENV KUBE_LINTER_URL=https://github.com/stackrox/kube-linter/releases/download/${KUBE_LINTER_VERSION}/kube-linter-linux.tar.gz
RUN <<EOF
curl -LSs "$KUBE_LINTER_URL" | tar xz
mv ./kube-linter /usr/local/bin/kube-linter
chmod +x /usr/local/bin/kube-linter
kube-linter version
EOF

# Conftest
# renovate: datasource=github-releases depName=open-policy-agent/conftest
ARG CONFTEST_VERSION=0.63.0
ENV CONFTEST_URL=https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz
RUN <<EOF
curl -LSs "$CONFTEST_URL" | tar xz
mv ./conftest /usr/local/bin/conftest
chmod +x /usr/local/bin/conftest
conftest --version
EOF

# Kustomize
# renovate: datasource=github-releases depName=kubernetes-sigs/kustomize
ARG KUSTOMIZE_VERSION=5.7.1
ENV KUSTOMIZE_URL=https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz
RUN <<EOF
curl -LSs "$KUSTOMIZE_URL" | tar xz
mv ./kustomize /usr/local/bin/kustomize
chmod +x /usr/local/bin/kustomize
kustomize version
EOF

# Nova
# renovate: datasource=github-releases depName=FairwindsOps/nova
ARG NOVA_VERSION=3.11.8
ENV NOVA_URL=https://github.com/FairwindsOps/nova/releases/download/v${NOVA_VERSION}/nova_${NOVA_VERSION}_linux_amd64.tar.gz
RUN <<EOF
curl -LSs "$NOVA_URL" | tar xz
mv ./nova /usr/local/bin/nova
chmod +x /usr/local/bin/nova
nova version
EOF

# Kubesec
# renovate: datasource=github-releases depName=controlplaneio/kubesec
ARG KUBESEC_VERSION=2.14.2
ENV KUBESEC_URL=https://github.com/controlplaneio/kubesec/releases/download/v${KUBESEC_VERSION}/kubesec_linux_amd64.tar.gz
RUN <<EOF
curl -LSs "$KUBESEC_URL" | tar xz
mv ./kubesec /usr/local/bin/kubesec
chmod +x /usr/local/bin/kubesec
kubesec version
EOF

# Kube No Trouble
# renovate: datasource=github-releases depName=doitintl/kube-no-trouble
ARG KUBENT_VERSION=0.7.3
ENV KUBENT_URL=https://github.com/doitintl/kube-no-trouble/releases/download/${KUBENT_VERSION}/kubent-${KUBENT_VERSION}-linux-amd64.tar.gz
RUN <<EOF
curl -LSs "$KUBENT_URL" | tar xz
mv ./kubent /usr/local/bin/kubent
chmod +x /usr/local/bin/kubent
EOF

# Trivy
# renovate: datasource=github-releases depName=aquasecurity/trivy
ARG TRIVY_VERSION=0.67.2
ENV TRIVY_URL=https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz
RUN <<EOF
curl -LSs "$TRIVY_URL" | tar xz
mv ./trivy /usr/local/bin/trivy
chmod +x /usr/local/bin/trivy
trivy --version
EOF

# yq
# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=4.48.1
ENV YQ_URL=https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64
RUN <<EOF
curl -LSsO "$YQ_URL"
mv ./yq_linux_amd64 /usr/local/bin/yq
chmod +x /usr/local/bin/yq
yq --version
EOF

# kubescape
# renovate: datasource=github-releases depName=armosec/kubescape
ARG KUBESCAPE_VERSION=3.0.42
ENV KUBESCAPE_URL=https://github.com/armosec/kubescape/releases/download/v${KUBESCAPE_VERSION}/kubescape-ubuntu-latest
RUN <<EOF
curl -LSsO "$KUBESCAPE_URL"
mv ./kubescape-ubuntu-latest /usr/local/bin/kubescape
chmod +x /usr/local/bin/kubescape
kubescape version
kubescape download framework nsa
kubescape download framework mitre
EOF

# gomplate
# renovate: datasource=github-releases depName=hairyhenderson/gomplate
ARG GOMPLATE_VERSION=4.3.3
ENV GOMPLATE_URL=https://github.com/hairyhenderson/gomplate/releases/download/v${GOMPLATE_VERSION}/gomplate_linux-amd64
RUN <<EOF
curl -LSsO "$GOMPLATE_URL"
mv ./gomplate_linux-amd64 /usr/local/bin/gomplate
chmod +x /usr/local/bin/gomplate
gomplate --version
EOF

# cosign
# renovate: datasource=github-releases depName=sigstore/cosign
ARG COSIGN_VERSION=2.6.1
ENV COSIGN_URL=https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign-linux-amd64
RUN <<EOF
curl -LSsO "$COSIGN_URL"
mv ./cosign-linux-amd64 /usr/local/bin/cosign
chmod +x /usr/local/bin/cosign
cosign version
EOF

# crane
# renovate: datasource=github-releases depName=google/go-containerregistry
ARG CRANE_VERSION=0.20.6
ENV CRANE_URL=https://github.com/google/go-containerregistry/releases/download/v${CRANE_VERSION}/go-containerregistry_Linux_x86_64.tar.gz
RUN <<EOF
curl -LSs "$CRANE_URL" | tar xz
mv ./crane /usr/local/bin/crane
chmod +x /usr/local/bin/crane
crane version
EOF

# kubepug
# renovate: datasource=github-releases depName=rikatz/kubepug
ARG KUBEPUG_VERSION=1.7.1
ENV KUBEPUG_URL=https://github.com/rikatz/kubepug/releases/download/v${KUBEPUG_VERSION}/kubepug_linux_amd64.tar.gz
RUN <<EOF
curl -LSs "$KUBEPUG_URL" | tar xz
mv ./kubepug /usr/local/bin/kubepug
chmod +x /usr/local/bin/kubepug
kubepug version
EOF

# container-structure-test
# renovate: datasource=github-releases depName=GoogleContainerTools/container-structure-test
ARG CONTAINER_STRUCTURE_TEST_VERSION=1.21.1
ENV CONTAINER_STRUCTURE_TEST_URL=https://github.com/GoogleContainerTools/container-structure-test/releases/download/v${CONTAINER_STRUCTURE_TEST_VERSION}/container-structure-test-linux-amd64
RUN <<EOF
curl -LSsO "$CONTAINER_STRUCTURE_TEST_URL"
mv container-structure-test-linux-amd64 container-structure-test
mv container-structure-test /usr/local/bin/
chmod +x /usr/local/bin/container-structure-test
container-structure-test version
EOF

# ah cli
# renovate: datasource=github-releases depName=artifacthub/hub
ARG AH_CLI_VERSION=1.21.0
ENV AH_CLI_URL=https://github.com/artifacthub/hub/releases/download/v${AH_CLI_VERSION}/ah_${AH_CLI_VERSION}_linux_amd64.tar.gz
RUN <<EOF
curl -LSs "$AH_CLI_URL" | tar xz
mv ./ah /usr/local/bin/ah
chmod +x /usr/local/bin/ah
ah version
EOF

# kyverno cli
# renovate: datasource=github-releases depName=kyverno/kyverno
ARG KYVERNO_CLI_VERSION=1.15.2
ENV KYVERNO_CLI_URL=https://github.com/kyverno/kyverno/releases/download/v${KYVERNO_CLI_VERSION}/kyverno-cli_v${KYVERNO_CLI_VERSION}_linux_x86_64.tar.gz
RUN <<EOF
curl -LSs "$KYVERNO_CLI_URL" | tar xz
mv ./kyverno /usr/local/bin/kyverno
chmod +x /usr/local/bin/kyverno
kyverno version
EOF

# s5cmd
# renovate: datasource=github-releases depName=peak/s5cmd
ARG S5CMD_VERSION=2.3.0
ENV S5CMD_CLI_URL=https://github.com/peak/s5cmd/releases/download/v${S5CMD_VERSION}/s5cmd_${S5CMD_VERSION}_Linux-64bit.tar.gz
RUN <<EOF
curl -LSs "$S5CMD_CLI_URL" | tar xz
mv ./s5cmd /usr/local/bin/s5cmd
chmod +x /usr/local/bin/s5cmd
s5cmd version
EOF

COPY scripts/ /usr/local/bin
COPY opt/ /opt/kube-powertools/
RUN chmod +x /usr/local/bin/*.sh

# hadolint ignore=DL3002
USER 0:0
WORKDIR /root/workspace

CMD ["/bin/bash"]
