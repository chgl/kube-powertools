# kube-powertools

![Last Version](https://img.shields.io/github/v/release/chgl/kube-powertools)
![License](https://img.shields.io/github/license/chgl/kube-powertools)
[![CI](https://github.com/chgl/kube-powertools/actions/workflows/ci.yaml/badge.svg)](https://github.com/chgl/kube-powertools/actions/workflows/ci.yaml)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/chgl/kube-powertools/badge)](https://scorecard.dev/viewer/?uri=github.com/chgl/kube-powertools)

[![SLSA 3](https://slsa.dev/images/gh-badge-level3.svg)](https://slsa.dev)

An always up to date collection of useful tools for your Kubernetes linting and auditing needs.

## Usage

Mount a folder containing your Helm or raw Kubernetes manifests:

```sh
docker run --rm -it -v $PWD:/root/workspace ghcr.io/chgl/kube-powertools:v2.4.27
```

The container image is pushed to these two registries:

- docker.io/chgl/kube-powertools:v2.4.27
- ghcr.io/chgl/kube-powertools:v2.4.27

## Helm Chart Repositories

The kube-powertools image includes a few helpful scripts to simplify working with Helm chart repositories.

### Linting

The image includes a [chart-powerlint.sh](scripts/chart-powerlint.sh) script which can be used to apply several linters to Helm chart repos.

For example, you can mount this repository into the `kube-powertools` container and run the following to lint the sample chart
in the `/samples/charts` dir:

```sh
$ docker run --rm -it -v $PWD:/root/workspace ghcr.io/chgl/kube-powertools:v2.4.27
bash-5.1# CHARTS_DIR=samples/charts chart-powerlint.sh
```

### Generating Chart Documentation

You can auto-generate and format Markdown docs from the chart's values.yaml using [generate-docs.sh](scripts/generate-docs.sh).
This scripts uses either `chart-doc-gen` if the chart dir contains a `doc.yaml`, or `helm-docs` if it doesn't.

### Generating Chart Schemas

You can auto-generate the Helm schema from the chart's values.yaml using [generate-schemas.sh](scripts/generate-schemas.sh).

### Generating CHANGELOG files

Finally, there's [generate-chart-changelog.sh](scripts/generate-chart-changelog.sh), which can be used to generate a CHANGELOG.md file from
the contents of a Chart.yaml's [artifacthub.io/changes](https://artifacthub.io/docs/topics/annotations/helm/#supported-annotations) annotation.

You can use this file in conjunction with the [chart-releaser](https://github.com/helm/chart-releaser) tool's `--release-notes-file` option to produce release notes for a GitHub release. See <https://github.com/chgl/charts/blob/master/.github/workflows/release.yaml#L32> and <https://github.com/chgl/charts/blob/master/.github/ct/ct.yaml#L16> for a sample workflow.

## What's included

- [kubectl](https://github.com/kubernetes/kubectl)
- [helm](https://github.com/helm/helm)
- [helm push plugin](https://github.com/chartmuseum/helm-push.git)
- [helm schema-gen plugin](https://github.com/knechtionscoding/helm-schema-gen)
- [helm unittest plugin](https://github.com/helm-unittest/helm-unittest)
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
- [kube-no-trouble](https://github.com/doitintl/kube-no-trouble)
- [trivy](https://github.com/aquasecurity/trivy)
- [yq](https://github.com/mikefarah/yq)
- [kubescape](https://github.com/armosec/kubescape)
- [gomplate](https://github.com/hairyhenderson/gomplate)
- [cosign](https://github.com/sigstore/cosign)
- [crane](https://github.com/google/go-containerregistry/tree/main/cmd/crane)
- [checkov](https://github.com/bridgecrewio/checkov)
- [kubepug](https://github.com/rikatz/kubepug)
- [container-structure-test](https://github.com/GoogleContainerTools/container-structure-test)
- [Artifact Hub CLI](https://github.com/artifacthub/hub)
- [Kyverno CLI](https://kyverno.io/docs/kyverno-cli/)
- [Docker CE CLI](https://docs.docker.com/engine/install/ubuntu/)

## Testing locally

```sh
docker build -t kube-powertools:dev .
$ docker run --rm -it -v $PWD:/root/workspace kube-powertools:dev
bash-5.1# CHARTS_DIR=samples/charts scripts/chart-powerlint.sh
```

## Image signature and provenance verification

Prerequisites:

- [cosign](https://github.com/sigstore/cosign/releases)
- [slsa-verifier](https://github.com/slsa-framework/slsa-verifier/releases)
- [crane](https://github.com/google/go-containerregistry/releases)

First, determine the digest of the container image to verify. This digest is also visible on
the packages page on GitHub: <https://github.com/chgl/kube-powertools/pkgs/container/kube-powertools>.

```sh
IMAGE=ghcr.io/chgl/kube-powertools:v2.4.27
IMAGE_DIGEST=$(crane digest $IMAGE)
IMAGE_TAG="${IMAGE#*:}"
```

Verify the container signature:

```sh
cosign verify \
   --certificate-oidc-issuer=https://token.actions.githubusercontent.com \
   --certificate-identity-regexp="https://github.com/chgl/.github/.github/workflows/standard-build.yaml@.*" \
   --certificate-github-workflow-name="ci" \
   --certificate-github-workflow-repository="chgl/kube-powertools" \
   --certificate-github-workflow-trigger="release" \
   --certificate-github-workflow-ref="refs/tags/${IMAGE_TAG}" \
   "ghcr.io/chgl/kube-powertools@${IMAGE_DIGEST}"
```

Verify the container SLSA level 3 provenance attestation:

```sh
slsa-verifier verify-image \
    --source-uri github.com/chgl/kube-powertools \
    --source-tag ${IMAGE_TAG} \
    --source-branch master \
    "ghcr.io/chgl/kube-powertools@${IMAGE_DIGEST}"
```

See also <https://github.com/slsa-framework/slsa-github-generator/tree/main/internal/builders/container#verification> for details on verifying the image integrity using automated policy controllers.
