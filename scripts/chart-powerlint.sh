#!/bin/bash
set -euox pipefail

CHARTS_DIR=${CHARTS_DIR:-"charts"}
SHOULD_UPDATE_DEPENDENCIES=${SHOULD_UPDATE_DEPENDENCIES:-""}

KUBERNETES_VERSIONS=${KUBERNETES_VERSIONS:-"1.19.0 1.20.0 1.21.0 1.22.0"}

POLARIS_SCORE_THRESHOLD=${POLARIS_SCORE_THRESHOLD:-90}
SKIP_KUBE_SCORE=${SKIP_KUBE_SCORE:-"1"}
KUBE_SCORE_ARGS=${KUBE_SCORE_ARGS:-""}
SKIP_KUBE_LINTER=${SKIP_KUBE_LINTER:-"1"}
SKIP_KUBE_SCAPE=${SKIP_KUBE_SCAPE:-"1"}

for CHART_PATH in "${CHARTS_DIR}"/*; do

  if test ! -f "${CHART_PATH}/Chart.yaml"; then
    echo "Skipping over ${CHART_PATH}"
    continue
  fi

  echo "Power-linting ${CHART_PATH}:"

  if [ "$SHOULD_UPDATE_DEPENDENCIES" = "1" ]; then
    echo "Updating helm dependencies"
    helm dependency update "${CHART_PATH}"
  fi

  echo "Helm lint..."
  helm lint "${CHART_PATH}"

  for KUBERNETES_VERSION in ${KUBERNETES_VERSIONS}; do
    echo "Validating against Kubernetes version $KUBERNETES_VERSION:"

    HELM_TEMPLATE_ARGS="--kube-version=v$KUBERNETES_VERSION"
    TEST_VALUES_FILE="$CHART_PATH/values-test.yaml"
    if [ -f "$TEST_VALUES_FILE" ]; then
      HELM_TEMPLATE_ARGS="$HELM_TEMPLATE_ARGS -f ${CHART_PATH}/values-test.yaml"
    fi

    echo "Kubeconform check..."

    if ! helm template ${HELM_TEMPLATE_ARGS} ${CHART_PATH} |
      kubeconform \
        -ignore-missing-schemas \
        -cache /tmp \
        -strict \
        -kubernetes-version "$KUBERNETES_VERSION" \
        -verbose \
        -exit-on-error \
        -summary -; then
      echo "kubeconform validation failed"
      exit 1
    fi

    echo "Pluto check..."

    if ! helm template ${HELM_TEMPLATE_ARGS} ${CHART_PATH} |
      pluto detect --target-versions k8s=v$KUBERNETES_VERSION -; then
      echo "Pluto failed"
      exit 1
    fi
  done

  echo "Polaris check..."

  POLARIS_AUDIT_ARGS=""
  POLARIS_CONFIG_FILE=".polaris.yaml"
  if [ -f "$POLARIS_CONFIG_FILE" ]; then
    POLARIS_AUDIT_ARGS="--config ${POLARIS_CONFIG_FILE}"
  fi

  if ! helm template ${HELM_TEMPLATE_ARGS} ${CHART_PATH} |
    polaris audit \
      --audit-path - \
      --format pretty \
      $POLARIS_AUDIT_ARGS \
      --set-exit-code-on-danger \
      --set-exit-code-below-score $POLARIS_SCORE_THRESHOLD; then
    echo "Polaris failed"
    exit 1
  fi

  if [ "$SKIP_KUBE_LINTER" -ne "1" ]; then
    echo "Kube-Linter check..."

    KUBE_LINTER_ARGS=""
    KUBE_LINTER_CONFIG_FILE=".kube-linter.yaml"
    if [ -f "$KUBE_LINTER_CONFIG_FILE" ]; then
      KUBE_LINTER_ARGS=" --config=${KUBE_LINTER_CONFIG_FILE}"
    fi

    if ! helm template ${HELM_TEMPLATE_ARGS} ${CHART_PATH} | kube-linter lint ${KUBE_LINTER_ARGS} -; then
      echo "Kube-Linter failed"
      exit 1
    fi
  fi

  if [ "$SKIP_KUBE_SCORE" -ne "1" ]; then
    echo "Kube-Score check..."
    if ! helm template ${HELM_TEMPLATE_ARGS} ${CHART_PATH} | kube-score score -; then
      echo "Kube-Score failed"
      exit 1
    fi
  fi

  if [ "$SKIP_KUBE_SCAPE" -ne "1" ]; then
    echo "kubescape nsa check..."
    if ! helm template ${HELM_TEMPLATE_ARGS} ${CHART_PATH} | kubescape scan framework nsa --use-from=/root/.kubescape/nsa.json -; then
      echo "kubescape for NSA framework failed"
      exit 1
    fi

    echo "kubescape mitre check..."
    if ! helm template ${HELM_TEMPLATE_ARGS} ${CHART_PATH} | kubescape scan framework mitre --use-from=/root/.kubescape/mitre.json -; then
      echo "kubescape for NSA framework failed"
      exit 1
    fi
  fi
done
