#!/bin/bash
set -euox pipefail

CHARTS_DIR=${CHARTS_DIR:-"charts"}
CHANGELOG_TEMPLATE_FILE_PATH=${CHANGELOG_TEMPLATE_FILE_PATH:-"/opt/kube-powertools/CHART-CHANGELOG.md.gotmpl"}

for dir in "$CHARTS_DIR"/*; do
  if test ! -f "${dir}/Chart.yaml"; then
    echo "No 'Chart.yaml' found in directory ${dir}. Skipping."
    continue
  fi

  CHART_NAME=$(basename "$dir")

  echo "Creating CHANGELOG.md for ${CHART_NAME}"

  # shellcheck disable=SC2002 # using cat makes the code look neater
  cat "$dir/Chart.yaml" |
    yq e '.annotations["artifacthub.io/changes"] // []' - |                                                               # extract the changes annotation, which is a YAML array
    yq -o json e '.' - |                                                                                                  # convert the YAML array to a JSON array
    jq 'group_by(.kind) | to_entries | map({key: .value[0].kind, value: .value})' - |                                     # group the JSON array by their 'kind' - ie. the type of change
    gomplate -d chart="$dir/Chart.yaml" -d changes=stdin:///in.json -f $CHANGELOG_TEMPLATE_FILE_PATH >"$dir/CHANGELOG.md" # use the JSON above as input to render the changelog
done
