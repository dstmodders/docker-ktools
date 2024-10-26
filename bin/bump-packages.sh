#!/bin/bash

# define constants
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
DOCKER_ALPINE_IMAGE='alpine:3.19.1'
DOCKER_DEBIAN_IMAGE='debian:bookworm-slim'
EXCLUDED_ALPINE_PACKAGES=()
EXCLUDED_DEBIAN_PACKAGES=('wget')
PROGRAM="$(basename "$0")"

readonly BASE_DIR
readonly DOCKER_ALPINE_IMAGE
readonly DOCKER_DEBIAN_IMAGE
readonly EXCLUDED_ALPINE_PACKAGES
readonly EXCLUDED_DEBIAN_PACKAGES
readonly PROGRAM

# define flags
FLAG_COMMIT=0
FLAG_DRY_RUN=0

usage() {
  cat <<EOF
Bump package in Dockerfiles.

Usage:
  $PROGRAM [flags]

Flags:
  -c, --commit    commit changes
  -d, --dry-run   only check and don't apply or commit any changes
  -h, --help      help for $PROGRAM
EOF
}

print_bold() {
  local value="$1"
  local output="${3:-1}"

  if [ "$DISABLE_COLORS" = '1' ] || ! [ -t 1 ]; then
    printf '%s' "$value" >&"$output"
  else
    printf "$(tput bold)%s$(tput sgr0)" "$value" >&"$output"
  fi
}

print_bold_color() {
  local color="$1"
  local value="$2"
  local output="${3:-1}"

  if [ "$DISABLE_COLORS" = '1' ] || ! [ -t 1 ]; then
    printf '%s' "$value" >&"$output"
  else
    printf "$(tput bold)$(tput setaf "$color")%s$(tput sgr0)" "$value" >&"$output"
  fi
}

print_error() {
  print_bold_color 1 "error: $1" 2
  echo '' >&2
}

print_title() {
  print_bold "[$1]"
  printf '\n\n'
}

get_packages_from_dockerfile() {
  local dockerfile="$1"
  sed -n \
      -e '/apk add --no-cache/,/&&/p' \
      -e '/apk add --no-cache --virtual/,/&&/p' \
      -e '/apt-get install -y --no-install-recommends/,/&&/p' \
      "$dockerfile" \
    | sed -E ':a;N;$!ba;s/\\\n/ /g' \
    | grep -oE '([a-zA-Z0-9+]+(-[a-zA-Z0-9+]+)*=[^[:space:]]+)' \
    | sed "s/'//g" \
    | sort \
    | uniq
}

get_latest_apk_package_version() {
  local name="$1"

  local escaped_name
  # shellcheck disable=SC2001
  escaped_name="$(echo "$name" | sed "s/[.[\*^$(){}+?|]/\\\\&/g")"

  local version
  version="$(docker run --rm -u root "$DOCKER_ALPINE_IMAGE" /bin/sh -c "
    apk update &>/dev/null \
    && apk info '$name' \
    | grep '^$name.*description' \
    | sed -E 's/^$escaped_name-(.*) description:/\1/' \
    | head -1
  " 2>&1)"

  if [ -z "$version" ]; then
    echo ''
  else
    echo "$version"
  fi
}

get_latest_apt_package_version() {
  local package_name="$1"

  local version
  version="$(docker run --rm -u root "$DOCKER_DEBIAN_IMAGE" /bin/bash -c "
    apt-get update &>/dev/null \
    && apt-cache show '$package_name' \
    | grep '^Version:' \
    | awk '{print \$2}' \
    | sort -V \
    | tail -n 1
  " 2>&1)"

  if [ -z "$version" ] || [ "$version" = 'E: No packages found' ]; then
    echo ''
  else
    echo "$version"
  fi
}

replace_package_in_dockerfile() {
  local escaped_package_name
  local escaped_current_version
  local escaped_new_version

  local dockerfile="$1"
  local package_name="$2"
  local current_version="$3"
  local new_version="$4"

  escape_for_sed() {
    printf '%s\n' "$1" | sed -e 's/[\/&]/\\&/g'
  }

  escaped_package_name="$(escape_for_sed "$package_name")"
  escaped_current_version="$(escape_for_sed "$current_version")"
  escaped_new_version="$(escape_for_sed "$new_version")"

  sed -i "s/${escaped_package_name}='${escaped_current_version}'/${escaped_package_name}='${escaped_new_version}'/g" "$dockerfile"
}

update_package_in_dockerfile() {
  local dockerfile="$1"
  local package_name="$2"
  local current_version="$3"
  local latest_version="$4"

  if [ -z "$latest_version" ]; then
    print_error "couldn't find the latest version for $package_name"
    exit 1
  fi

  if [ "$current_version" != "$latest_version" ]; then
    printf '%s %s => %s ' "$package_name" "$current_version" "$latest_version"
    print_bold_color 3 'outdated'
  else
    printf '%s %s ' "$package_name" "$current_version"
    print_bold_color 2 'up-to-date'
  fi
  printf '\n'

  if [ "$FLAG_DRY_RUN" -eq 1 ]; then
    return 0
  fi

  replace_package_in_dockerfile "$dockerfile" "$package_name" "$current_version" "$latest_version"
}

commit_changes() {
  local dockerfile="$1"
  local commit_message_first_line="$2"
  local commit_message="$3"

  if [ "$FLAG_DRY_RUN" -eq 0 ] && [ "$FLAG_COMMIT" -eq 1 ]; then
    printf 'Committing...'
    git add "$dockerfile"

    if [ -n "$(git diff --cached --name-only)" ]; then
      printf '\n'
      echo '---'
      git commit -m "$commit_message_first_line" -m "$commit_message"
    else
      printf ' Skipped\n'
    fi
  fi
}

is_excluded_alpine_package() {
  local package_name="$1"
  for excluded_package in "${EXCLUDED_ALPINE_PACKAGES[@]}"; do
    if [ "$excluded_package" == "$package_name" ]; then
      return 0
    fi
  done
  return 1
}

is_excluded_debian_package() {
  local package_name="$1"
  for excluded_package in "${EXCLUDED_DEBIAN_PACKAGES[@]}"; do
    if [ "$excluded_package" == "$package_name" ]; then
      return 0
    fi
  done
  return 1
}

update_alpine_dockerfile() {
  local commit_list=()
  local dockerfile="$1"
  local commit_message_first_line="$2"

  while IFS= read -r line; do
    package_name="$(echo "$line" | cut -d '=' -f 1)"

    if is_excluded_alpine_package "$package_name"; then
      continue
    fi

    current_version="$(echo "$line" | cut -d '=' -f 2)"
    latest_version="$(get_latest_apk_package_version "$package_name")"
    update_package_in_dockerfile "$dockerfile" "$package_name" "$current_version" "$latest_version"

    if [ "$FLAG_DRY_RUN" -eq 0 ] && [ "$FLAG_COMMIT" -eq 1 ] && [ "$current_version" != "$latest_version" ]; then
      commit_list+=("- Bump $package_name from $current_version to $latest_version")
    fi
  done <<< "$(get_packages_from_dockerfile "$dockerfile")"

  if [ "$FLAG_DRY_RUN" -eq 0 ] && [ "$FLAG_COMMIT" -eq 1 ] && [ "${#commit_list[@]}" -gt 0 ]; then
    mapfile -t sorted_commit_list < <(printf "%s\n" "${commit_list[@]}" | sort)
    commit_message="$(printf "%s\n" "${sorted_commit_list[@]}")"
    echo '---'
    commit_changes "$dockerfile" "$commit_message_first_line" "$commit_message"
  fi
}

update_debian_dockerfile() {
  local commit_list=()
  local dockerfile="$1"
  local commit_message_first_line="$2"

  while IFS= read -r line; do
    package_name="$(echo "$line" | cut -d '=' -f 1)"

    if is_excluded_debian_package "$package_name"; then
      continue
    fi

    current_version="$(echo "$line" | cut -d '=' -f 2)"
    latest_version="$(get_latest_apt_package_version "$package_name")"
    update_package_in_dockerfile "$dockerfile" "$package_name" "$current_version" "$latest_version"

    if [ "$FLAG_DRY_RUN" -eq 0 ] && [ "$FLAG_COMMIT" -eq 1 ] && [ "$current_version" != "$latest_version" ]; then
      commit_list+=("- Bump $package_name from $current_version to $latest_version")
    fi
  done <<< "$(get_packages_from_dockerfile "$dockerfile")"

  if [ "$FLAG_DRY_RUN" -eq 0 ] && [ "$FLAG_COMMIT" -eq 1 ] && [ "${#commit_list[@]}" -gt 0 ]; then
    mapfile -t sorted_commit_list < <(printf "%s\n" "${commit_list[@]}" | sort)
    commit_message="$(printf "%s\n" "${sorted_commit_list[@]}")"
    echo '---'
    commit_changes "$dockerfile" "$commit_message_first_line" "$commit_message"
  fi
}

cd "$BASE_DIR/.." || exit 1

while [ $# -gt 0 ]; do
  key="$1"
  case "$key" in
    -c|--commit)
      FLAG_COMMIT=1
      ;;
    -d|--dry-run)
      FLAG_DRY_RUN=1
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
readonly FLAG_DRY_RUN

print_title 'DOCKER'
echo 'Pulling Docker images...'
echo '---'
docker pull "$DOCKER_ALPINE_IMAGE"
echo '---'
docker pull "$DOCKER_DEBIAN_IMAGE"
printf '\n'

print_title 'LATEST ALPINE PACKAGES'
update_alpine_dockerfile './latest/alpine/Dockerfile' 'Bump packages in latest alpine image'
printf '\n'

print_title 'LATEST DEBIAN PACKAGES'
update_debian_dockerfile './latest/debian/Dockerfile' 'Bump packages in latest debian image'
printf '\n'

print_title 'OFFICIAL ALPINE PACKAGES'
update_alpine_dockerfile './official/alpine/Dockerfile' 'Bump packages in official alpine image'
printf '\n'

print_title 'OFFICIAL DEBIAN PACKAGES'
update_debian_dockerfile './official/debian/Dockerfile' 'Bump packages in official debian image'
