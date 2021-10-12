#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
COMMIT_ID=$(git rev-parse --verify HEAD)
DISTS=('alpine' 'debian')
VERSIONS=()

cd "${BASE_DIR}" || exit 1

mapfile -t VERSIONS < <(jq -r 'keys[]' ./versions.json)
IFS=$'\n' VERSIONS=($(sort -rV <<< "${VERSIONS[*]}")); unset IFS

readonly BASE_DIR
readonly COMMIT_ID
readonly DISTS
readonly VERSIONS

# https://stackoverflow.com/a/17841619
function join_by {
  local d="${1-}"
  local f="${2-}"
  if shift 2; then
    printf %s "$f" "${@/#/$d}";
  fi
}

function jq_value {
  local from="$1"
  local key="$2"
  local name="$3"
  jq -r ".[${key}] | .${name}" "${from}"
}

function print_url() {
  local tags="$1"
  local commit="$2"
  local dist="$3"
  local official="$4"

  local url="[$tags](https://github.com/dstmodders/docker-ktools/blob/${commit}/latest/${dist}/Dockerfile)"
  if [ "${official}" == 'true' ]; then
    url="[$tags](https://github.com/dstmodders/docker-ktools/blob/${commit}/official/${dist}/Dockerfile)"
  fi

  echo "- ${url}"
}

printf "## Supported tags and respective \`Dockerfile\` links\n\n"

for v in "${VERSIONS[@]}"; do
  for dist in "${DISTS[@]}"; do
    commit="${COMMIT_ID}"
    version=$(jq -r ".[${v}] | .version" ./versions.json)
    imagemagick=$(jq_value ./versions.json "${v}" 'imagemagick')
    latest=$(jq_value ./versions.json "${v}" 'latest')
    official=$(jq_value ./versions.json "${v}" 'official')
    previous=$(jq -c ".[${v}] | .previous" < ./versions.json)

    tag_dist="${dist}"
    tag_full="${version}-imagemagick-${imagemagick}-${dist}"
    tag_version="${version}"

    if [ "${official}" == 'true' ]; then
      tag_dist="official-${tag_dist}"
      tag_full="official-${tag_full}"
      tag_version="official-${tag_version}"
    fi

    tags=''
    if [ "${dist}" == 'alpine' ]; then
      tags="\`${tag_full}\`, \`${tag_version}\`, \`${tag_dist}\`"
      if [ "${latest}" == 'true' ]; then
        if [ "${official}" == 'true' ]; then
          tags="${tags}, \`official-latest\`"
        else
          tags="${tags}, \`latest\`"
        fi
      fi
    else
      tags="\`${tag_full}\`, \`${tag_dist}\`"
    fi

    print_url "${tags}" "${commit}" "${dist}" "${official}"
  done

  if [ "${previous}" != "null" ]; then
    mapfile -t commits < <(jq -r 'keys[]' <<< "${previous}")
    imagemagick=$(jq -c ".[].imagemagick" <<< "${previous}" | xargs)

    for dist in "${DISTS[@]}"; do
      for commit in "${commits[@]}"; do
        tag_full="${version}-imagemagick-${imagemagick}-${dist}"
        tags="\`${tag_full}\`"
        print_url "${tags}" "${commit}" "${dist}" "${official}"
      done
    done
  fi
done
