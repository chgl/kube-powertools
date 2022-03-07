FROM alpine:3.15
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
WORKDIR /usr/src/app
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
ARG HELM_VERSION=3.8.0
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
ARG CHART_DOC_GEN_VERSION=0.4.7
ENV CHART_DOC_GEN_URL=https://github.com/kubepack/chart-doc-gen/releases/download/v"${CHART_DOC_GEN_VERSION}"/chart-doc-gen-linux-amd64
RUN curl -LSsO $CHART_DOC_GEN_URL && \
    mv chart-doc-gen-linux-amd64 /usr/local/bin/chart-doc-gen && \
    chmod +x /usr/local/bin/chart-doc-gen

# Helm Docs
ARG HELM_DOCS_VERSION=1.7.0
ENV HELM_DOCS_URL=https://github.com/norwoodj/helm-docs/releases/download/v${HELM_DOCS_VERSION}/helm-docs_${HELM_DOCS_VERSION}_Linux_x86_64.tar.gz
RUN curl -LSs $HELM_DOCS_URL | tar xz && \
    mv ./helm-docs /usr/local/bin/helm-docs && \
    chmod +x /usr/local/bin/helm-docs && \
    helm-docs --version

# Kubeval
ARG KUBEVAL_VERSION=v0.16.1
ENV KUBEVAL_URL=https://github.com/instrumenta/kubeval/releases/download/${KUBEVAL_VERSION}/kubeval-linux-amd64.tar.gz
RUN curl -LSs $KUBEVAL_URL | tar xz && \
    mv ./kubeval /usr/local/bin/kubeval && \
    chmod +x /usr/local/bin/kubeval && \
    kubeval --version

# Kubeconform
ARG KUBECONFORM_VERSION=0.4.13
ENV KUBECONFORM_URL=https://github.com/yannh/kubeconform/releases/download/v${KUBECONFORM_VERSION}/kubeconform-linux-amd64.tar.gz
RUN curl -LSs $KUBECONFORM_URL | tar xz && \
    mv ./kubeconform /usr/local/bin/kubeconform && \
    chmod +x /usr/local/bin/kubeconform && \
    kubeconform -h

# Kube Score
ARG KUBE_SCORE_VERSION=1.14.0
ENV KUBE_SCORE_URL=https://github.com/zegl/kube-score/releases/download/v${KUBE_SCORE_VERSION}/kube-score_${KUBE_SCORE_VERSION}_linux_amd64
RUN curl -LSs $KUBE_SCORE_URL -o kube-score && \
    mv kube-score /usr/local/bin/kube-score && \
    chmod +x /usr/local/bin/kube-score && \
    kube-score version

# Chart Testing
ARG CT_VERSION=3.5.0
ENV CT_URL=https://github.com/helm/chart-testing/releases/download/v"${CT_VERSION}"/chart-testing_"${CT_VERSION}"_linux_amd64.tar.gz
RUN curl -LSs $CT_URL | tar xz && \
    mv ./ct  /usr/local/bin/ct && \
    chmod +x /usr/local/bin/ct && \
    ct version

# Fairwinds Polaris
ARG POLARIS_VERSION=v5.0.1
ENV POLARIS_URL=https://github.com/FairwindsOps/polaris/releases/download/${POLARIS_VERSION}/polaris_linux_amd64.tar.gz
RUN curl -LSs $POLARIS_URL | tar xz && \
    mv ./polaris  /usr/local/bin/polaris && \
    chmod +x /usr/local/bin/polaris && \
    polaris version

# Fairwinds Pluto
ARG PLUTO_VERSION=5.5.1
ENV PLUTO_URL=https://github.com/FairwindsOps/pluto/releases/download/v${PLUTO_VERSION}/pluto_${PLUTO_VERSION}_linux_amd64.tar.gz
RUN curl -LSs $PLUTO_URL | tar xz && \
    mv ./pluto /usr/local/bin/pluto && \
    chmod +x /usr/local/bin/pluto && \
    pluto version

# Stackrox Kube Linter
ARG KUBE_LINTER_VERSION=0.2.5
ENV KUBE_LINTER_URL=https://github.com/stackrox/kube-linter/releases/download/${KUBE_LINTER_VERSION}/kube-linter-linux.tar.gz
RUN curl -LSs $KUBE_LINTER_URL | tar xz && \
    mv ./kube-linter /usr/local/bin/kube-linter && \
    chmod +x /usr/local/bin/kube-linter && \
    kube-linter version

# Conftest
ARG CONFTEST_VERSION=0.30.0
ENV CONFTEST_URL=https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz
RUN curl -LSs $CONFTEST_URL | tar xz && \
    mv ./conftest /usr/local/bin/conftest && \
    chmod +x /usr/local/bin/conftest && \
    conftest --version

# Kustomize
ARG KUSTOMIZE_VERSION=4.5.2
ENV KUSTOMIZE_URL=https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz
RUN curl -LSs $KUSTOMIZE_URL | tar xz && \
    mv ./kustomize /usr/local/bin/kustomize && \
    chmod +x /usr/local/bin/kustomize && \
    kustomize version

# Nova
ARG NOVA_VERSION=3.0.2
ENV NOVA_URL=https://github.com/FairwindsOps/nova/releases/download/${NOVA_VERSION}/nova_${NOVA_VERSION}_linux_amd64.tar.gz
RUN curl -LSs $NOVA_URL | tar xz && \
    mv ./nova /usr/local/bin/nova && \
    chmod +x /usr/local/bin/nova && \
    nova version

# Kubesec
ARG KUBESEC_VERSION=2.11.4
ENV KUBESEC_URL=https://github.com/controlplaneio/kubesec/releases/download/v${KUBESEC_VERSION}/kubesec_linux_amd64.tar.gz
RUN curl -LSs $KUBESEC_URL | tar xz && \
    mv ./kubesec /usr/local/bin/kubesec && \
    chmod +x /usr/local/bin/kubesec && \
    kubesec version

# Kube No Trouble
ARG KUBENT_VERSION=0.5.1
ENV KUBENT_URL=https://github.com/doitintl/kube-no-trouble/releases/download/${KUBENT_VERSION}/kubent-${KUBENT_VERSION}-linux-amd64.tar.gz
RUN curl -LSs $KUBENT_URL | tar xz && \
    mv ./kubent /usr/local/bin/kubent && \
    chmod +x /usr/local/bin/kubent

# Trivy
ARG TRIVY_VERSION=0.24.2
ENV TRIVY_URL=https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz
RUN curl -LSs $TRIVY_URL | tar xz && \
    mv ./trivy /usr/local/bin/trivy && \
    chmod +x /usr/local/bin/trivy && \
    trivy --version

# yq
ARG YQ_VERSION=4.21.1
ENV YQ_URL=https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64
RUN curl -LSsO $YQ_URL && \
    mv ./yq_linux_amd64 /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq && \
    yq --version

# kubescape
ARG KUBESCAPE_VERSION=2.0.149
ENV KUBESCAPE_URL=https://github.com/armosec/kubescape/releases/download/v${KUBESCAPE_VERSION}/kubescape-ubuntu-latest
RUN curl -LSsO $KUBESCAPE_URL && \
    mv ./kubescape-ubuntu-latest /usr/local/bin/kubescape && \
    chmod +x /usr/local/bin/kubescape && \
    kubescape version && \
    kubescape download framework nsa && \
    kubescape download framework mitre

# gomplate
ARG GOMPLATE_VERSION=3.10.0
ENV GOMPLATE_URL=https://github.com/hairyhenderson/gomplate/releases/download/v${GOMPLATE_VERSION}/gomplate_linux-amd64
RUN curl -LSsO $GOMPLATE_URL && \
    mv ./gomplate_linux-amd64 /usr/local/bin/gomplate && \
    chmod +x /usr/local/bin/gomplate && \
    gomplate --version

COPY scripts/ /usr/local/bin
COPY opt/ /opt/kube-powertools/
RUN chmod +x /usr/local/bin/*.sh

CMD ["/bin/bash"]
