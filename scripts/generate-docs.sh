#!/bin/bash
set -euox pipefail

echo "Running chart-doc-gen..."

CHARTS_DIR=${CHARTS_DIR:-"charts"}

for chart in "${CHARTS_DIR}"/*; do
    echo "Generating docs for $chart:"

    if test ! -f "${chart}/Chart.yaml"; then
        echo "No 'Chart.yaml' found in directory ${chart}. Skipping."
        continue
    fi

    # if there's a 'doc.yaml' present in the chart dir, use chart-doc-gen,
    # otherwise use helm-docs
    if test -f "${chart}/doc.yaml"; then
        echo "Found doc.yaml file in ${chart}, using chart-doc-gen"
        if test -f "${chart}/README.tpl"; then
            echo "${chart}/README.tpl exists. Using it as a template input."
            chart-doc-gen --doc="${chart}/doc.yaml" --values="${chart}/values.yaml" --template="${chart}/README.tpl" >"${chart}/README.md"
        else
            chart-doc-gen --doc="${chart}/doc.yaml" --values="${chart}/values.yaml" >"${chart}/README.md"
        fi
    else
        echo "No doc.yaml found in ${chart}, using helm-docs"
        helm-docs --chart-search-root=${chart}
    fi
done

echo "Running prettier..."

prettier --write "${CHARTS_DIR}"/**/README.md
