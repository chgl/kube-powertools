# sample

[sample](https://github.com/OHDSI) - sample chart for deploying to Kubernetes.

## TL;DR;

```console
$ helm repo add chgl https://chgl.github.io/charts
$ helm repo update
$ helm install sample chgl/sample -n sample
```

## Introduction

This chart deploys the sample for Azure. on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes v1.16+
- Helm v3

## Installing the Chart

To install the chart with the release name `sample`:

```console
$ helm install sample chgl/sample -n sample
```

The command deploys the sample for Azure. on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `sample`:

```console
$ helm delete sample -n sample
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `sample` chart and their default values.

| Parameter                                  | Description                                                                                                            | Default        |
| ------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------- | -------------- |
| replicaCount                               |                                                                                                                        | `1`            |
| image.repository                           |                                                                                                                        | `nginx`        |
| image.pullPolicy                           |                                                                                                                        | `IfNotPresent` |
| image.tag                                  | Overrides the image tag whose default is the chart appVersion.                                                         | `""`           |
| imagePullSecrets                           |                                                                                                                        | `[]`           |
| nameOverride                               |                                                                                                                        | `""`           |
| fullnameOverride                           |                                                                                                                        | `""`           |
| serviceAccount.create                      | Specifies whether a service account should be created                                                                  | `true`         |
| serviceAccount.annotations                 | Annotations to add to the service account                                                                              | `{}`           |
| serviceAccount.name                        | The name of the service account to use. If not set and create is true, a name is generated using the fullname template | `""`           |
| podAnnotations                             |                                                                                                                        | `{}`           |
| podSecurityContext                         |                                                                                                                        | `{}`           |
| securityContext                            |                                                                                                                        | `{}`           |
| service.type                               |                                                                                                                        | `ClusterIP`    |
| service.port                               |                                                                                                                        | `80`           |
| ingress.enabled                            |                                                                                                                        | `false`        |
| ingress.annotations                        |                                                                                                                        | `{}`           |
| ingress.tls                                |                                                                                                                        | `[]`           |
| resources                                  |                                                                                                                        | `{}`           |
| autoscaling.enabled                        |                                                                                                                        | `false`        |
| autoscaling.minReplicas                    |                                                                                                                        | `1`            |
| autoscaling.maxReplicas                    |                                                                                                                        | `100`          |
| autoscaling.targetCPUUtilizationPercentage |                                                                                                                        | `80`           |
| nodeSelector                               |                                                                                                                        | `{}`           |
| tolerations                                |                                                                                                                        | `[]`           |
| affinity                                   |                                                                                                                        | `{}`           |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```console
$ helm install sample chgl/sample -n sample --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```console
$ helm install sample chgl/sample -n sample --values values.yaml
```
