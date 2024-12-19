#!/bin/bash
set -euox pipefail

echo "Running helm-schema..."

CHARTS_DIR=${CHARTS_DIR:-"charts"}

for chart in "${CHARTS_DIR}"/*; do
  echo "Generating schema for $chart:"

  if test ! -f "${chart}/Chart.yaml"; then
    echo "No 'Chart.yaml' found in directory ${chart}. Skipping."
    continue
  fi

  helm schema

done
