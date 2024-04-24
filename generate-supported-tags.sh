#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
COMMIT_ID="$(git rev-parse --verify HEAD)"
DISTS=('alpine' 'debian')
JSON="$(cat ./versions.json)"
LATEST_VERSIONS_KEYS=()
OFFICIAL_VERSIONS_KEYS=()
REPOSITORY='https://github.com/dstmodders/docker-ktools'

mapfile -t LATEST_VERSIONS_KEYS < <(jq -r '.latest | keys[]' <<< "$JSON")
# shellcheck disable=SC2207
IFS=$'\n' LATEST_VERSIONS_KEYS=($(sort -rV <<< "${LATEST_VERSIONS_KEYS[*]}")); unset IFS

mapfile -t OFFICIAL_VERSIONS_KEYS < <(jq -r '.official | keys[]' <<< "$JSON")
# shellcheck disable=SC2207
IFS=$'\n' OFFICIAL_VERSIONS_KEYS=($(sort -rV <<< "${OFFICIAL_VERSIONS_KEYS[*]}")); unset IFS

readonly BASE_DIR
readonly COMMIT_ID
readonly DISTS
readonly JSON
readonly LATEST_VERSIONS_KEYS
readonly OFFICIAL_VERSIONS_KEYS
readonly REPOSITORY

function print_url() {
  local tags="$1"
  local commit="$2"
  local directory="$3"
  local url="[$tags]($REPOSITORY/blob/$commit/$directory/Dockerfile)"
  echo "- $url"
}

cd "$BASE_DIR" || exit 1

printf "## Supported tags and respective \`Dockerfile\` links\n\n"

# reference: 4.5.1-imagemagick-7.1.1-30-alpine, 4.5.1, alpine, latest
for key in "${LATEST_VERSIONS_KEYS[@]}"; do
  for dist in "${DISTS[@]}"; do
    commit="$COMMIT_ID"
    version="$(jq -r ".latest | .[$key] | .version" <<< "$JSON")"
    imagemagick="$(jq -r ".latest | .[$key] | .imagemagick_version" <<< "$JSON")"
    latest="$(jq -r ".latest | .[$key] | .latest" <<< "$JSON")"
    previous="$(jq -r ".latest | .[$key] | .previous" <<< "$JSON")"

    tag_dist="$dist"
    tag_full="$version-imagemagick-$imagemagick-$dist"
    tag_version="$version"

    tags=''
    if [ "$dist" == 'alpine' ]; then
      tags="\`$tag_full\`, \`$tag_version\`, \`$tag_dist\`"
      if [ "$latest" == 'true' ]; then
        tags="$tags, \`latest\`"
      fi
    else
      tags="\`$tag_full\`, \`$tag_dist\`"
    fi

    print_url "$tags" "$commit" "latest/$dist"
  done

  if [ "$previous" != "null" ]; then
    mapfile -t commits < <(jq -r 'keys[]' <<< "$previous")
    imagemagick="$(jq -c ".[].imagemagick_version" <<< "$previous" | xargs)"

    for dist in "${DISTS[@]}"; do
      for commit in "${commits[@]}"; do
        tag_full="$version-imagemagick-$imagemagick-$dist"
        tags="\`$tag_full\`"
        print_url "$tags" "$commit" "latest/$dist"
      done
    done
  fi
done

# reference: official-4.4.0-imagemagick-6.9.13-8-alpine, official-4.4.0, official-alpine, official-latest
for key in "${OFFICIAL_VERSIONS_KEYS[@]}"; do
  for dist in "${DISTS[@]}"; do
    commit="$COMMIT_ID"
    version="$(jq -r ".official | .[$key] | .version" <<< "$JSON")"
    imagemagick="$(jq -r ".official | .[$key] | .imagemagick_version" <<< "$JSON")"
    latest="$(jq -r ".official | .[$key] | .latest" <<< "$JSON")"
    previous="$(jq -r ".official | .[$key] | .previous" <<< "$JSON")"

    tag_dist="official-$dist"
    tag_full="official-$version-imagemagick-$imagemagick-$dist"
    tag_version="official-$version"

    tags=''
    if [ "$dist" == 'alpine' ]; then
      tags="\`$tag_full\`, \`$tag_version\`, \`$tag_dist\`"
      if [ "$latest" == 'true' ]; then
        tags="$tags, \`official-latest\`"
      fi
    else
      tags="\`$tag_full\`, \`$tag_dist\`"
    fi

    print_url "$tags" "$commit" "official/$dist"
  done

  if [ "$previous" != "null" ]; then
    mapfile -t commits < <(jq -r 'keys[]' <<< "$previous")
    imagemagick="$(jq -c ".[].imagemagick_version" <<< "$previous" | xargs)"

    for dist in "${DISTS[@]}"; do
      for commit in "${commits[@]}"; do
        tag_full="$version-imagemagick-$imagemagick-$dist"
        tags="\`$tag_full\`"
        print_url "$tags" "$commit" "official/$dist"
      done
    done
  fi
done
