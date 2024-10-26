#!/usr/bin/env bash

# define constants
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
COMMIT_ID="$(git rev-parse --verify HEAD)"
COMMIT_MESSAGE='Change tags in DOCKERHUB.md and README.md'
DISTS=('alpine' 'debian')
HEADING_FOR_OVERVIEW='## Overview'
HEADING_FOR_TAGS="## Supported tags and respective \`Dockerfile\` links"
JSON="$(cat ./versions.json)"
LATEST_VERSIONS_KEYS=()
OFFICIAL_VERSIONS_KEYS=()
PROGRAM="$(basename "$0")"
REPOSITORY='https://github.com/dstmodders/docker-ktools'

extract_and_sort_keys() {
  local key_path="$1"
  jq -r "$key_path | keys[]" <<< "$JSON" | sort -rV
}

mapfile -t LATEST_VERSIONS_KEYS < <(extract_and_sort_keys '.latest')
mapfile -t OFFICIAL_VERSIONS_KEYS < <(extract_and_sort_keys '.official')

readonly BASE_DIR
readonly COMMIT_ID
readonly COMMIT_MESSAGE
readonly DISTS
readonly HEADING_FOR_OVERVIEW
readonly HEADING_FOR_TAGS
readonly JSON
readonly LATEST_VERSIONS_KEYS
readonly OFFICIAL_VERSIONS_KEYS
readonly PROGRAM
readonly REPOSITORY

# define flags
FLAG_COMMIT=0

usage() {
  cat <<EOF
Generate supported tags.

Usage:
  $PROGRAM [flags]

Flags:
  -c, --commit   commit changes
  -h, --help     help for $PROGRAM
EOF
}

print_url() {
  local tags="$1"
  local commit="$2"
  local directory="$3"
  local url="[$tags]($REPOSITORY/blob/$commit/$directory/Dockerfile)"
  echo "- $url"
}

# reference:
#   4.5.1-imagemagick-7.1.1-39-alpine, 4.5.1-alpine, 4.5.1, alpine, latest
#   4.5.1-imagemagick-7.1.1-39-debian, 4.5.1-debian, debian
#   4.5.0-imagemagick-7.1.1-39-alpine, 4.5.0-alpine, 4.5.0
#   4.5.0-imagemagick-7.1.1-39-debian, 4.5.0-debian
print_latest_tags() {
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
}

# reference:
#   official-4.4.0-imagemagick-6.9.13-17-alpine, official-4.4.0-alpine, official-4.4.0, official-alpine, official-latest, official
#   official-4.4.0-imagemagick-6.9.13-17-debian, official-4.4.0-debian, official-debian
#   official-4.3.1-imagemagick-6.9.13-17-alpine, official-4.3.1-alpine, official-4.3.1
#   official-4.3.1-imagemagick-6.9.13-17-debian, official-4.3.1-debian
print_official_tags() {
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
}

replace() {
  local content="$1"
  for file in ./DOCKERHUB.md ./README.md; do
    sed -i "/$HEADING_FOR_TAGS/,/$HEADING_FOR_OVERVIEW/ {
      /$HEADING_FOR_TAGS/!{
        /$HEADING_FOR_OVERVIEW/!d
      }
      /$HEADING_FOR_TAGS/!b
      r /dev/stdin
      d
    }" "$file" <<< "$content"
  done
}

cd "$BASE_DIR/.." || exit 1

while [ $# -gt 0 ]; do
  key="$1"
  case "$key" in
    -c|--commit)
      FLAG_COMMIT=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      print_error 'unrecognized flag'
      exit 1
      ;;
    *)
      ;;
  esac
  shift 1
done

# define extra constants
readonly FLAG_COMMIT

printf "%s\n\n" "$HEADING_FOR_TAGS"

if [ "$FLAG_COMMIT" -eq 1 ]; then
  latest_tags="$(print_latest_tags)"
  official_tags="$(print_official_tags)"
  echo "$latest_tags"
  echo "$official_tags"
  echo '---'
  if [ "$FLAG_COMMIT" -eq 1 ]; then
    replace "$HEADING_FOR_TAGS"$'\n'$'\n'"$latest_tags"$'\n'"$official_tags"$'\n'
    printf 'Committing...'
    git add \
      DOCKERHUB.md \
      README.md
    if [ -n "$(git diff --cached --name-only)" ]; then
      printf '\n'
      echo '---'
      git commit -m "$COMMIT_MESSAGE"
    else
      printf ' Skipped\n'
    fi
  fi
else
  print_latest_tags
  print_official_tags
fi
