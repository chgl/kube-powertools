# kube-powertools

![Docker Image Version (latest semver)](https://img.shields.io/docker/v/chgl/kube-powertools?sort=semver)

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
