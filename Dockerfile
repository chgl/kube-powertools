FROM alpine:3.16
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
WORKDIR /tmp
# hadolint ignore=DL3013,DL3016,DL3018
RUN apk add --no-cache \
    git \
    curl \
    nodejs \
    npm \
    python3 \
    py-pip \
    bash \
    jq \
    tar && \
    npm install -g prettier markdownlint-cli && \
    pip install --no-cache-dir yamale yamllint pre-commit

# kubectl
ARG KUBECTL_VERSION=1.23.0
ENV KUBECTL_URL=https://storage.googleapis.com/kubernetes-release/release/v"${KUBECTL_VERSION}"/bin/linux/amd64/kubectl
RUN curl -LSsO $KUBECTL_URL && \
    mv ./kubectl /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    kubectl version --client

# Helm
# renovate: datasource=github-releases depName=helm/helm
ARG HELM_VERSION=3.9.0
ENV HELM_URL=https://get.helm.sh/helm-v"${HELM_VERSION}"-linux-amd64.tar.gz
RUN curl -LSs $HELM_URL | tar xz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    helm version

# Helm push plugin
RUN helm plugin install https://github.com/chartmuseum/helm-push.git

# Helm Local Chart Version Plugin
RUN helm plugin install https://github.com/mbenabda/helm-local-chart-version && \
    helm local-chart-version version

# Chart Doc Gen
# renovate: datasource=github-releases depName=kubepack/chart-doc-gen
ARG CHART_DOC_GEN_VERSION=0.4.7
ENV CHART_DOC_GEN_URL=https://github.com/kubepack/chart-doc-gen/releases/download/v"${CHART_DOC_GEN_VERSION}"/chart-doc-gen-linux-amd64
RUN curl -LSsO $CHART_DOC_GEN_URL && \
    mv chart-doc-gen-linux-amd64 /usr/local/bin/chart-doc-gen && \
    chmod +x /usr/local/bin/chart-doc-gen

# Helm Docs
# renovate: datasource=github-releases depName=norwoodj/helm-docs
ARG HELM_DOCS_VERSION=1.11.0
ENV HELM_DOCS_URL=https://github.com/norwoodj/helm-docs/releases/download/v${HELM_DOCS_VERSION}/helm-docs_${HELM_DOCS_VERSION}_Linux_x86_64.tar.gz
RUN curl -LSs $HELM_DOCS_URL | tar xz && \
    mv ./helm-docs /usr/local/bin/helm-docs && \
    chmod +x /usr/local/bin/helm-docs && \
    helm-docs --version

# Kubeval
# renovate: datasource=github-releases depName=instrumenta/kubeval
ARG KUBEVAL_VERSION=v0.16.1
ENV KUBEVAL_URL=https://github.com/instrumenta/kubeval/releases/download/${KUBEVAL_VERSION}/kubeval-linux-amd64.tar.gz
RUN curl -LSs $KUBEVAL_URL | tar xz && \
    mv ./kubeval /usr/local/bin/kubeval && \
    chmod +x /usr/local/bin/kubeval && \
    kubeval --version

# Kubeconform
# renovate: datasource=github-releases depName=yannh/kubeconform
ARG KUBECONFORM_VERSION=0.4.13
ENV KUBECONFORM_URL=https://github.com/yannh/kubeconform/releases/download/v${KUBECONFORM_VERSION}/kubeconform-linux-amd64.tar.gz
RUN curl -LSs $KUBECONFORM_URL | tar xz && \
    mv ./kubeconform /usr/local/bin/kubeconform && \
    chmod +x /usr/local/bin/kubeconform && \
    kubeconform -h

# Kube Score
# renovate: datasource=github-releases depName=zegl/kube-score
ARG KUBE_SCORE_VERSION=1.14.0
ENV KUBE_SCORE_URL=https://github.com/zegl/kube-score/releases/download/v${KUBE_SCORE_VERSION}/kube-score_${KUBE_SCORE_VERSION}_linux_amd64
RUN curl -LSs $KUBE_SCORE_URL -o kube-score && \
    mv kube-score /usr/local/bin/kube-score && \
    chmod +x /usr/local/bin/kube-score && \
    kube-score version

# Chart Testing
# renovate: datasource=github-releases depName=helm/chart-testing
ARG CT_VERSION=3.6.0
ENV CT_URL=https://github.com/helm/chart-testing/releases/download/v"${CT_VERSION}"/chart-testing_"${CT_VERSION}"_linux_amd64.tar.gz
RUN curl -LSs $CT_URL | tar xz && \
    mv ./ct  /usr/local/bin/ct && \
    chmod +x /usr/local/bin/ct && \
    ct version

# Fairwinds Polaris
# renovate: datasource=github-releases depName=FairwindsOps/polaris
ARG POLARIS_VERSION=6.0.0
ENV POLARIS_URL=https://github.com/FairwindsOps/polaris/releases/download/${POLARIS_VERSION}/polaris_linux_amd64.tar.gz
RUN curl -LSs $POLARIS_URL | tar xz && \
    mv ./polaris  /usr/local/bin/polaris && \
    chmod +x /usr/local/bin/polaris && \
    polaris version

# Fairwinds Pluto
# renovate: datasource=github-releases depName=FairwindsOps/pluto
ARG PLUTO_VERSION=5.10.1
ENV PLUTO_URL=https://github.com/FairwindsOps/pluto/releases/download/v${PLUTO_VERSION}/pluto_${PLUTO_VERSION}_linux_amd64.tar.gz
RUN curl -LSs $PLUTO_URL | tar xz && \
    mv ./pluto /usr/local/bin/pluto && \
    chmod +x /usr/local/bin/pluto && \
    pluto version

# Stackrox Kube Linter
# renovate: datasource=github-releases depName=stackrox/kube-linter
ARG KUBE_LINTER_VERSION=0.3.0
ENV KUBE_LINTER_URL=https://github.com/stackrox/kube-linter/releases/download/${KUBE_LINTER_VERSION}/kube-linter-linux.tar.gz
RUN curl -LSs $KUBE_LINTER_URL | tar xz && \
    mv ./kube-linter /usr/local/bin/kube-linter && \
    chmod +x /usr/local/bin/kube-linter && \
    kube-linter version

# Conftest
# renovate: datasource=github-releases depName=open-policy-agent/conftest
ARG CONFTEST_VERSION=0.32.1
ENV CONFTEST_URL=https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz
RUN curl -LSs $CONFTEST_URL | tar xz && \
    mv ./conftest /usr/local/bin/conftest && \
    chmod +x /usr/local/bin/conftest && \
    conftest --version

# Kustomize
# renovate: datasource=github-releases depName=kubernetes-sigs/kustomize
ARG KUSTOMIZE_VERSION=4.5.5
ENV KUSTOMIZE_URL=https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz
RUN curl -LSs $KUSTOMIZE_URL | tar xz && \
    mv ./kustomize /usr/local/bin/kustomize && \
    chmod +x /usr/local/bin/kustomize && \
    kustomize version

# Nova
# renovate: datasource=github-releases depName=FairwindsOps/nova
ARG NOVA_VERSION=3.2.0
ENV NOVA_URL=https://github.com/FairwindsOps/nova/releases/download/${NOVA_VERSION}/nova_${NOVA_VERSION}_linux_amd64.tar.gz
RUN curl -LSs $NOVA_URL | tar xz && \
    mv ./nova /usr/local/bin/nova && \
    chmod +x /usr/local/bin/nova && \
    nova version

# Kubesec
# renovate: datasource=github-releases depName=controlplaneio/kubesec
ARG KUBESEC_VERSION=2.11.4
ENV KUBESEC_URL=https://github.com/controlplaneio/kubesec/releases/download/v${KUBESEC_VERSION}/kubesec_linux_amd64.tar.gz
RUN curl -LSs $KUBESEC_URL | tar xz && \
    mv ./kubesec /usr/local/bin/kubesec && \
    chmod +x /usr/local/bin/kubesec && \
    kubesec version

# Kube No Trouble
# renovate: datasource=github-releases depName=doitintl/kube-no-trouble
ARG KUBENT_VERSION=0.5.1
ENV KUBENT_URL=https://github.com/doitintl/kube-no-trouble/releases/download/${KUBENT_VERSION}/kubent-${KUBENT_VERSION}-linux-amd64.tar.gz
RUN curl -LSs $KUBENT_URL | tar xz && \
    mv ./kubent /usr/local/bin/kubent && \
    chmod +x /usr/local/bin/kubent

# Trivy
# renovate: datasource=github-releases depName=aquasecurity/trivy
ARG TRIVY_VERSION=0.29.2
ENV TRIVY_URL=https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz
RUN curl -LSs $TRIVY_URL | tar xz && \
    mv ./trivy /usr/local/bin/trivy && \
    chmod +x /usr/local/bin/trivy && \
    trivy --version

# yq
# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=4.25.3
ENV YQ_URL=https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64
RUN curl -LSsO $YQ_URL && \
    mv ./yq_linux_amd64 /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq && \
    yq --version

# kubescape
# renovate: datasource=github-releases depName=armosec/kubescape
ARG KUBESCAPE_VERSION=2.0.160
ENV KUBESCAPE_URL=https://github.com/armosec/kubescape/releases/download/v${KUBESCAPE_VERSION}/kubescape-ubuntu-latest
RUN curl -LSsO $KUBESCAPE_URL && \
    mv ./kubescape-ubuntu-latest /usr/local/bin/kubescape && \
    chmod +x /usr/local/bin/kubescape && \
    kubescape version && \
    kubescape download framework nsa && \
    kubescape download framework mitre

# gomplate
# renovate: datasource=github-releases depName=hairyhenderson/gomplate
ARG GOMPLATE_VERSION=3.11.1
ENV GOMPLATE_URL=https://github.com/hairyhenderson/gomplate/releases/download/v${GOMPLATE_VERSION}/gomplate_linux-amd64
RUN curl -LSsO $GOMPLATE_URL && \
    mv ./gomplate_linux-amd64 /usr/local/bin/gomplate && \
    chmod +x /usr/local/bin/gomplate && \
    gomplate --version

# cosign
# renovate: datasource=github-releases depName=sigstore/cosign
ARG COSIGN_VERSION=1.9.0
ENV COSIGN_URL=https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign-linux-amd64
RUN curl -LSsO $COSIGN_URL && \
    mv ./cosign-linux-amd64 /usr/local/bin/cosign && \
    chmod +x /usr/local/bin/cosign && \
    cosign version

# crane
# renovate: datasource=github-releases depName=google/go-containerregistry
ARG CRANE_VERSION=0.10.0
ENV CRANE_URL=https://github.com/google/go-containerregistry/releases/download/v${CRANE_VERSION}/go-containerregistry_Linux_x86_64.tar.gz
RUN curl -LSs $CRANE_URL | tar xz && \
    mv ./crane /usr/local/bin/crane && \
    chmod +x /usr/local/bin/crane && \
    crane version

COPY scripts/ /usr/local/bin
COPY opt/ /opt/kube-powertools/
RUN chmod +x /usr/local/bin/*.sh
WORKDIR /usr/src/app

CMD ["/bin/bash"]
