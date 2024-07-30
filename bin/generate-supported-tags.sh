#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
COMMIT_ID="$(git rev-parse --verify HEAD)"
DISTS=('alpine' 'debian')
JSON="$(cat ./versions.json)"
LATEST_VERSIONS_KEYS=()
OFFICIAL_VERSIONS_KEYS=()
REPOSITORY='https://github.com/dstmodders/docker-ktools'

extract_and_sort_keys() {
  local key_path="$1"
  jq -r "$key_path | keys[]" <<< "$JSON" | sort -rV
}

mapfile -t LATEST_VERSIONS_KEYS < <(extract_and_sort_keys '.latest')
mapfile -t OFFICIAL_VERSIONS_KEYS < <(extract_and_sort_keys '.official')

readonly BASE_DIR
readonly COMMIT_ID
readonly DISTS
readonly JSON
readonly LATEST_VERSIONS_KEYS
readonly OFFICIAL_VERSIONS_KEYS
readonly REPOSITORY

print_url() {
  local tags="$1"
  local commit="$2"
  local directory="$3"
  local url="[$tags]($REPOSITORY/blob/$commit/$directory/Dockerfile)"
  echo "- $url"
}

cd "$BASE_DIR" || exit 1

printf "## Supported tags and respective \`Dockerfile\` links\n\n"

# reference:
#   4.5.1-imagemagick-7.1.1-36-alpine, 4.5.1-alpine, 4.5.1, alpine, latest
#   4.5.1-imagemagick-7.1.1-36-debian, 4.5.1-debian, debian
#   4.5.0-imagemagick-7.1.1-36-alpine, 4.5.0-alpine, 4.5.0
#   4.5.0-imagemagick-7.1.1-36-debian, 4.5.0-debian
for key in "${LATEST_VERSIONS_KEYS[@]}"; do
  for dist in "${DISTS[@]}"; do
    imagemagick_version="$(jq -r ".latest | .[$key] | .imagemagick_version" <<< "$JSON")"
    latest="$(jq -r ".latest | .[$key] | .latest" <<< "$JSON")"
    version="$(jq -r ".latest | .[$key] | .version" <<< "$JSON")"

    tag_version_imagemagick_version_dist="$version-imagemagick-$imagemagick_version-$dist"
    tag_version_dist="$version-$dist"
    tag_version="$version"
    tag_dist="$dist"

    tags="\`$tag_version_imagemagick_version_dist\`, \`$tag_version_dist\`"
    case "$dist" in
      alpine)
        tags="$tags, \`$tag_version\`"
        if [ "$latest" == 'true' ]; then
          tags="$tags, \`$tag_dist\`, \`latest\`"
        fi
        ;;
      debian)
        if [ "$latest" == 'true' ]; then
          tags="$tags, \`$tag_dist\`"
        fi
        ;;
    esac

    print_url "$tags" "$COMMIT_ID" "latest/$dist"
  done
done

# reference:
#   official-4.4.0-imagemagick-6.9.13-14-alpine, official-4.4.0-alpine, official-4.4.0, official-alpine, official-latest, official
#   official-4.4.0-imagemagick-6.9.13-14-debian, official-4.4.0-debian, official-debian
#   official-4.3.1-imagemagick-6.9.13-14-alpine, official-4.3.1-alpine, official-4.3.1
#   official-4.3.1-imagemagick-6.9.13-14-debian, official-4.3.1-debian
for key in "${OFFICIAL_VERSIONS_KEYS[@]}"; do
  for dist in "${DISTS[@]}"; do
    prefix='official-'
    imagemagick_version="$(jq -r ".official | .[$key] | .imagemagick_version" <<< "$JSON")"
    latest="$(jq -r ".official | .[$key] | .latest" <<< "$JSON")"
    version="$(jq -r ".official | .[$key] | .version" <<< "$JSON")"

    tag_version_imagemagick_version_dist="$prefix$version-imagemagick-$imagemagick_version-$dist"
    tag_version_dist="$prefix$version-$dist"
    tag_version="$prefix$version"
    tag_dist="$prefix$dist"

    tags="\`$tag_version_imagemagick_version_dist\`, \`$tag_version_dist\`"
    case "$dist" in
      alpine)
        tags="$tags, \`$tag_version\`"
        if [ "$latest" == 'true' ]; then
          tags="$tags, \`$tag_dist\`, \`$(printf '%slatest' "$prefix")\`, \`official\`"
        fi
        ;;
      debian)
        if [ "$latest" == 'true' ]; then
          tags="$tags, \`$tag_dist\`"
        fi
        ;;
    esac

    print_url "$tags" "$COMMIT_ID" "official/$dist"
  done
done
