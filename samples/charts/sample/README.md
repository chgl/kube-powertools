# sample

[sample](https://github.com/OHDSI) - sample chart for deploying to Kubernetes.

## TL;DR;

```bash
$ helm repo add chgl https://chgl.github.io/charts
$ helm repo update
$ helm search repo chgl/sample --version=0.1.0
$ helm upgrade -i sample chgl/sample -n sample --create-namespace --version=0.1.0
```

## Introduction

This chart deploys the sample for Azure. on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes v1.16+
- Helm v3

## Installing the Chart

To install/upgrade the chart with the release name `sample`:

```bash
$ helm upgrade -i sample chgl/sample -n sample --create-namespace --version=0.1.0
```

The command deploys the sample for Azure. on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `sample`:

```bash
$ helm uninstall sample -n sample
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `sample` chart and their default values.

| Parameter                                  | Description                                                                                                            | Default                                                                                       |
| ------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| replicaCount                               |                                                                                                                        | <code>2</code>                                                                                |
| image.repository                           |                                                                                                                        | <code>docker.io/nginxinc/nginx-unprivileged</code>                                            |
| image.pullPolicy                           |                                                                                                                        | <code>IfNotPresent</code>                                                                     |
| image.tag                                  | Overrides the image tag whose default is the chart appVersion.                                                         | <code>"1.24.0@sha256:7c950a48f7d480f223633b3e7e15f88186a6b3455576bafc5403e808893edbed"</code> |
| imagePullSecrets                           |                                                                                                                        | <code>[]</code>                                                                               |
| nameOverride                               |                                                                                                                        | <code>""</code>                                                                               |
| fullnameOverride                           |                                                                                                                        | <code>""</code>                                                                               |
| serviceAccount.create                      | Specifies whether a service account should be created                                                                  | <code>true</code>                                                                             |
| serviceAccount.annotations                 | Annotations to add to the service account                                                                              | <code>{}</code>                                                                               |
| serviceAccount.name                        | The name of the service account to use. If not set and create is true, a name is generated using the fullname template | <code>""</code>                                                                               |
| podAnnotations                             |                                                                                                                        | <code>{}</code>                                                                               |
| podSecurityContext.runAsNonRoot            |                                                                                                                        | <code>true</code>                                                                             |
| podSecurityContext.seccompProfile.type     |                                                                                                                        | <code>RuntimeDefault</code>                                                                   |
| securityContext.readOnlyRootFilesystem     |                                                                                                                        | <code>true</code>                                                                             |
| securityContext.runAsNonRoot               |                                                                                                                        | <code>true</code>                                                                             |
| securityContext.runAsUser                  |                                                                                                                        | <code>65534</code>                                                                            |
| securityContext.runAsGroup                 |                                                                                                                        | <code>65534</code>                                                                            |
| securityContext.allowPrivilegeEscalation   |                                                                                                                        | <code>false</code>                                                                            |
| securityContext.seccompProfile.type        |                                                                                                                        | <code>RuntimeDefault</code>                                                                   |
| service.type                               |                                                                                                                        | <code>ClusterIP</code>                                                                        |
| service.port                               |                                                                                                                        | <code>80</code>                                                                               |
| ingress.enabled                            |                                                                                                                        | <code>false</code>                                                                            |
| ingress.annotations                        |                                                                                                                        | <code>{}</code>                                                                               |
| ingress.tls                                |                                                                                                                        | <code>[]</code>                                                                               |
| resources.limits.cpu                       |                                                                                                                        | <code>100m</code>                                                                             |
| resources.limits.memory                    |                                                                                                                        | <code>128Mi</code>                                                                            |
| resources.requests.cpu                     |                                                                                                                        | <code>100m</code>                                                                             |
| resources.requests.memory                  |                                                                                                                        | <code>128Mi</code>                                                                            |
| autoscaling.enabled                        |                                                                                                                        | <code>false</code>                                                                            |
| autoscaling.minReplicas                    |                                                                                                                        | <code>1</code>                                                                                |
| autoscaling.maxReplicas                    |                                                                                                                        | <code>100</code>                                                                              |
| autoscaling.targetCPUUtilizationPercentage |                                                                                                                        | <code>80</code>                                                                               |
| nodeSelector                               |                                                                                                                        | <code>{}</code>                                                                               |
| tolerations                                |                                                                                                                        | <code>[]</code>                                                                               |
| affinity                                   |                                                                                                                        | <code>{}</code>                                                                               |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i sample chgl/sample -n sample --create-namespace --version=0.1.0 --set replicaCount=2
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i sample chgl/sample -n sample --create-namespace --version=0.1.0 --values values.yaml
```
