#!/bin/bash
set -euo pipefail

echo "Running chart-doc-gen..."

CHARTS_DIR=${CHARTS_DIR:-"charts"}

for chart in "${CHARTS_DIR}"/*; do
    echo "Chart $chart:"

    if test ! -f "${chart}/Chart.yaml"; then
        echo "Skipping over ${chart}"
        continue
    fi

    if test -f "${chart}/README.tpl"; then
        echo "${chart}/README.tpl exists"
        chart-doc-gen -d="${chart}/doc.yaml" -v="${chart}/values.yaml" -t="${chart}/README.tpl" >"${chart}/README.md"
    else
        chart-doc-gen -d="${chart}/doc.yaml" -v="${chart}/values.yaml" >"${chart}/README.md"
    fi
done

echo "Running prettier..."

prettier --write "${CHARTS_DIR}"/**/README.md
