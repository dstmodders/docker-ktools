#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
COMMIT_ID="$(git rev-parse --verify HEAD)"
DISTS=('alpine' 'debian')
JSON="$(cat ./versions.json)"
REPOSITORY='https://github.com/dstmodders/docker-ktools'
VERSIONS_KEYS=()

mapfile -t VERSIONS_KEYS < <(jq -r 'keys[]' <<< "$JSON")
# shellcheck disable=SC2207
IFS=$'\n' VERSIONS_KEYS=($(sort -rV <<< "${VERSIONS_KEYS[*]}")); unset IFS

readonly BASE_DIR
readonly COMMIT_ID
readonly DISTS
readonly JSON
readonly REPOSITORY
readonly VERSIONS_KEYS

function print_url() {
  local tags="$1"
  local commit="$2"
  local directory="$3"
  local url="[$tags]($REPOSITORY/blob/$commit/$directory/Dockerfile)"
  echo "- $url"
}

cd "$BASE_DIR" || exit 1

printf "## Supported tags and respective \`Dockerfile\` links\n\n"

# reference:
#   4.5.1-imagemagick-7.1.1-30-alpine, 4.5.1, alpine, latest
#   official-4.4.0-imagemagick-6.9.13-8-alpine, official-4.4.0, official-alpine, official-latest
for key in "${VERSIONS_KEYS[@]}"; do
  for dist in "${DISTS[@]}"; do
    commit="$COMMIT_ID"
    version=$(jq -r ".[$key] | .version" <<< "$JSON")
    imagemagick=$(jq -r ".[$key].imagemagick" <<< "$JSON")
    latest=$(jq -r ".[$key].latest" <<< "$JSON")
    official=$(jq -r ".[$key].official" <<< "$JSON")
    previous=$(jq -r ".[$key].previous" <<< "$JSON")

    tag_dist="$dist"
    tag_full="$version-imagemagick-$imagemagick-$dist"
    tag_version="$version"

    if [ "$official" == 'true' ]; then
      tag_dist="official-$tag_dist"
      tag_full="official-$tag_full"
      tag_version="official-$tag_version"
    fi

    tags=''
    if [ "$dist" == 'alpine' ]; then
      tags="\`$tag_full\`, \`$tag_version\`, \`$tag_dist\`"
      if [ "$latest" == 'true' ]; then
        if [ "$official" == 'true' ]; then
          tags="$tags, \`official-latest\`"
        else
          tags="$tags, \`latest\`"
        fi
      fi
    else
      tags="\`$tag_full\`, \`$tag_dist\`"
    fi

    if [ "$official" == 'true' ]; then
      print_url "$tags" "$commit" "official/$dist"
    else
      print_url "$tags" "$commit" "latest/$dist"
    fi
  done

  if [ "$previous" != "null" ]; then
    mapfile -t commits < <(jq -r 'keys[]' <<< "$previous")
    imagemagick=$(jq -c ".[].imagemagick" <<< "$previous" | xargs)

    for dist in "${DISTS[@]}"; do
      for commit in "${commits[@]}"; do
        tag_full="$version-imagemagick-$imagemagick-$dist"
        tags="\`$tag_full\`"
        if [ "$official" == 'true' ]; then
          print_url "$tags" "$commit" "official/$dist"
        else
          print_url "$tags" "$commit" "latest/$dist"
        fi
      done
    done
  fi
done
