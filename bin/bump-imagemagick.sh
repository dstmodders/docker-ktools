#!/usr/bin/env bash
#
# Bump the latest or official ImageMagick version.
#
# Usage:
#   bump-imagemagick.sh [flags] [<image set>] [<version>]
#
# Examples:
#   bump-imagemagick.sh
#   bump-imagemagick.sh -d latest 7.1.2-1
#
# Arguments:
#   <image set>     Image set: "latest" or "official"
#   <version>       ImageMagick version
#
# Flags:
#   -c, --commit    Commit changes
#   -d, --dry-run   Only check and don't apply or commit any changes
#   -h, --help      Show this help message
#
# Environment Variables:
#   GITHUB_TOKEN    GitHub token for API requests to avoid rate limiting
#                   (default "")
#
#   NO_COLOR        Set to 1 to disable terminal colors
#                   (see no-color.org, default "0")
#
set -euo pipefail

# define constants
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
DOCKERHUB_START_LINE=16
JSON="$(cat "${BASE_DIR}/../versions.json")"
README_START_LINE=28

readonly BASE_DIR
readonly DOCKERHUB_START_LINE
readonly JSON
readonly README_START_LINE

# shellcheck disable=SC1091
source "${BASE_DIR}/common.sh"

# define defaults for environment variables
GITHUB_TOKEN="${GITHUB_TOKEN:-}"
NO_COLOR="${NO_COLOR:-0}"

# define flags
FLAG_COMMIT=0
FLAG_DRY_RUN=0

print_step_failed() {
  local value="${1:-Failed}"
  print_bold_color 1 "${value}"
  printf '\n'
}

version_exists() {
  local repo="$1"
  local version="$2"
  local -a curl_args=(-sf)

  if [ -n "${GITHUB_TOKEN:-}" ]; then
    curl_args+=(-H "Authorization: token ${GITHUB_TOKEN}")
  fi

  # shellcheck disable=SC2086
  curl "${curl_args[@]}" "https://api.github.com/repos/ImageMagick/${repo}/tags?per_page=100" 2> /dev/null \
    | jq -e "any(.name == \"${version}\")" > /dev/null
}

summary() {
  local dir="$1"
  local old_version="$2"
  local new_version="$3"
  local files=(
    "${dir}/alpine/Dockerfile"
    "${dir}/debian/Dockerfile"
    'DOCKERHUB.md'
    'README.md'
    'bin/bump-supported-tags.sh'
    'versions.json'
  )

  print_step_dotted 'Printing affected files'
  printf '\n'
  print_separator
  mapfile -t sorted_files < <(printf "%s\n" "${files[@]}" | LC_ALL=C sort)
  for file in "${sorted_files[@]}"; do
    printf '%s\n' "${file}"
  done
}

replace() {
  local dir="$1"
  local old_version="$2"
  local new_version="$3"

  print_step_dotted 'Replacing'
  sed -i "${DOCKERHUB_START_LINE},\$s/\`${old_version}\`/\`${new_version}\`/g" ./DOCKERHUB.md
  sed -i "${README_START_LINE},\$s/\`${old_version}\`/\`${new_version}\`/g" ./README.md
  sed -i "s/\"${old_version}\"/\"${new_version}\"/" ./versions.json
  sed -i "/^# reference:/,/^[^#]/s/imagemagick-${old_version}/imagemagick-${new_version}/g" ./bin/bump-supported-tags.sh
  sed -i "s/^ARG IMAGEMAGICK_VERSION=\"${old_version}\"$/ARG IMAGEMAGICK_VERSION=\"${new_version}\"/" "./${dir}/alpine/Dockerfile"
  sed -i "s/^ARG IMAGEMAGICK_VERSION=\"${old_version}\"$/ARG IMAGEMAGICK_VERSION=\"${new_version}\"/" "./${dir}/debian/Dockerfile"
  print_step_success
}

cd "${BASE_DIR}/.." || exit 1

name=''
new_version=''

while [ $# -gt 0 ]; do
  key="$1"
  case "${key}" in
    latest | official)
      name="${key}"
      ;;
    -c | --commit)
      FLAG_COMMIT=1
      ;;
    -d | --dry-run)
      FLAG_DRY_RUN=1
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    -*)
      die 'unrecognized flag'
      ;;
    *)
      new_version="${key}"
      ;;
  esac
  shift 1
done

readonly FLAG_COMMIT
readonly FLAG_DRY_RUN

if ! command -v curl > /dev/null 2>&1; then
  die 'curl is required'
fi

trap interrupt SIGINT

if [ -z "${name}" ]; then
  print_step_dotted 'Choose image set option'
  printf '\n'
  print_separator

  options=('latest' 'official')
  select opt in "${options[@]}"; do
    case "${opt}" in
      latest)
        name='latest'
        print_separator
        break
        ;;
      official)
        name='official'
        print_separator
        break
        ;;
      *)
        print_error 'unrecognized option (choose number 1 or 2)'
        ;;
    esac
  done
fi

if [ -z "${name}" ]; then
  die 'image set not specified'
fi

old_version=''
case "${name}" in
  latest)
    old_version="$(jq -r ".${name}[] | select(.imagemagick_legacy != true) | .imagemagick_version" <<< "${JSON}" | head -n 1)"
    ;;
  official)
    old_version="$(jq -r ".${name}[] | select(.imagemagick_legacy == true) | .imagemagick_version" <<< "${JSON}" | head -n 1)"
    ;;
esac

if [ -z "${new_version}" ]; then
  printf 'Current version: %s\n' "${old_version}"
  while [ -z "${new_version}" ]; do
    read -rp "Enter new ${name} version: " new_version
    if [ -z "${new_version}" ]; then
      print_error 'empty version'
    fi
  done
  print_separator
fi

print_step_dotted 'Setting image set' "${name}"
print_step_success

print_step_dotted 'Setting new version' "${new_version}"
print_step_success

if [ "${name}" = 'latest' ]; then
  upstream_repo='ImageMagick'
else
  upstream_repo='ImageMagick6'
fi

print_step_dotted 'Setting upstream repository' "${upstream_repo}"
print_step_success

print_step_dotted 'Checking tag existence' "${new_version}"
if ! version_exists "${upstream_repo}" "${new_version}"; then
  print_step_failed
  print_separator
  die "couldn't find tag ${new_version} in the ${upstream_repo} upstream repository"
else
  print_step_success
fi

summary "${name}" "${old_version}" "${new_version}"
if [ "${FLAG_DRY_RUN}" -eq 1 ]; then
  complete 3 'Dry-run completed'
fi

print_separator
replace "${name}" "${old_version}" "${new_version}"

if [ "${FLAG_COMMIT}" -eq 1 ]; then
  print_step_dotted 'Committing'
  if [ "${old_version}" != "${new_version}" ]; then
    git add \
      "${name}/alpine/Dockerfile" \
      "${name}/debian/Dockerfile" \
      DOCKERHUB.md \
      README.md \
      bin/bump-supported-tags.sh \
      versions.json
    if [ -n "$(git diff --cached --name-only)" ]; then
      printf '\n'
      print_separator
      git commit -m "Bump ImageMagick from ${old_version} to ${new_version}"
    else
      print_step_skipped
    fi
  else
    print_step_skipped
  fi
fi

complete 2 'Bump completed'
