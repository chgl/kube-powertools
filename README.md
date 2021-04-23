# kube-powertools

![Last Version](https://img.shields.io/github/v/release/chgl/kube-powertools)
![License](https://img.shields.io/github/license/chgl/kube-powertools)
![Docker Pull](https://img.shields.io/docker/pulls/chgl/kube-powertools)
![CI](https://github.com/chgl/kube-powertools/workflows/ci/badge)

An always up to date collection of useful tools for your Kubernetes linting and auditing needs.

## Usage

Mount a folder containing your Helm or raw Kubernetes manifests:

```sh
docker run --rm -it -v $PWD:/usr/src/app quay.io/chgl/kube-powertools:latest
```

The container image is pushed to three registries:

- `quay.io/chgl/kube-powertools:latest`
- `docker.io/chgl/kube-powertools:latest`
- `ghcr.io/chgl/kube-powertools:latest`

You can use the `vX.Y.Z` image tags corresponding to the [releases](https://github.com/chgl/kube-powertools/releases)
instead of using `latest`.

## Helm Chart Repositories

The container includes a [chart-powerlint.sh](scripts/chart-powerlint.sh) script which can be used to apply several linters to Helm chart repos.

For example, you can mount this repository into the `kube-powertools` container and run the following to lint the sample chart
in the `/samples/charts` dir:

```sh
$ docker run --rm -it -v $PWD:/usr/src/app quay.io/chgl/kube-powertools:latest
bash-5.1# CHARTS_DIR=samples/charts chart-powerlint.sh
```

Additionally, you can auto-generate and format Markdown docs from the chart's values.yaml using [generate-docs.sh](scripts/generate-docs.sh)

## What's included

- [kubectl](https://github.com/kubernetes/kubectl)
- [helm](https://github.com/helm/helm)
- [helm push plugin](https://github.com/chartmuseum/helm-push.git)
- [helm-local-chart-version](https://github.com/mbenabda/helm-local-chart-version)
- [chart-doc-gen](https://github.com/kubepack/chart-doc-gen)
- [kubeval](https://github.com/instrumenta/kubeval)
- [kube-score](https://github.com/zegl/kube-score)
- [chart-testing](https://github.com/helm/chart-testing)
- [polaris](https://github.com/FairwindsOps/polaris)
- [pluto](https://github.com/FairwindsOps/pluto)
- [helm-docs](https://github.com/norwoodj/helm-docs)
- [kube-linter](https://github.com/stackrox/kube-linter)
- [kustomize](https://github.com/kubernetes-sigs/kustomize)
- [conftest](https://github.com/open-policy-agent/conftest)
- [nova](https://github.com/FairwindsOps/nova)
- [kubesec](https://github.com/controlplaneio/kubesec)
- [kubeconform](https://github.com/yannh/kubeconform)
