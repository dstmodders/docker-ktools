#!/usr/bin/env bash

# define constants
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
DOCKERHUB_START_LINE=16
JSON="$(cat "$BASE_DIR/../versions.json")"
PROGRAM="$(basename "$0")"
README_START_LINE=28

readonly BASE_DIR
readonly DOCKERHUB_START_LINE
readonly JSON
readonly PROGRAM
readonly README_START_LINE

# define flags
FLAG_COMMIT=0

usage() {
  cat <<EOF
Bump the latest or legacy ImageMagick version.

Usage:
  $PROGRAM [flags] [latest|legacy] [version]

Flags:
  -c, --commit   commit changes
  -h, --help     help for $PROGRAM
EOF
}

print_bold() {
  local value="$1"
  local output="${2:-1}"

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

summary() {
  local dir="$1"
  local old_version="$2"
  local new_version="$3"
  local files=(
    "$dir/alpine/Dockerfile"
    "$dir/debian/Dockerfile"
    'DOCKERHUB.md'
    'README.md'
    'bin/bump-supported-tags.sh'
    'versions.json'
  )

  print_bold '[FILES]'
  printf '\n\n'
  mapfile -t sorted_files < <(printf "%s\n" "${files[@]}" | LC_ALL=C sort)
  for file in "${sorted_files[@]}"; do
    echo "$file"
  done

  printf '\n'
  print_bold '[VERSION]'
  printf '\n\n'

  echo "Current: $old_version"
  echo "New: $new_version"
}

replace() {
  local dir="$1"
  local old_version="$2"
  local new_version="$3"

  printf 'Replacing...'
  sed -i "$DOCKERHUB_START_LINE,\$s/\`$old_version\`/\`$new_version\`/g" ./DOCKERHUB.md
  sed -i "$README_START_LINE,\$s/\`$old_version\`/\`$new_version\`/g" ./README.md
  sed -i "s/\"$old_version\"/\"$new_version\"/" ./versions.json
  sed -i "/^# reference:/,/^[^#]/s/imagemagick-$old_version/imagemagick-$new_version/g" ./bin/bump-supported-tags.sh
  sed -i "s/^ARG IMAGEMAGICK_VERSION=\"$old_version\"$/ARG IMAGEMAGICK_VERSION=\"$new_version\"/" "./$dir/alpine/Dockerfile"
  sed -i "s/^ARG IMAGEMAGICK_VERSION=\"$old_version\"$/ARG IMAGEMAGICK_VERSION=\"$new_version\"/" "./$dir/debian/Dockerfile"
  printf ' Done\n'
}

cd "$BASE_DIR/.." || exit 1

name=''

while [ $# -gt 0 ]; do
  key="$1"
  case "$key" in
    latest|legacy)
      name="$key"
      ;;
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
      new_version="$key"
      ;;
  esac
  shift 1
done

readonly FLAG_COMMIT

if [ -z "$name" ]; then
  echo 'Choose bump option:'
  options=('latest' 'legacy')
  select opt in "${options[@]}"; do
    case "$opt" in
      latest) name='latest'; break ;;
      legacy) name='legacy'; break ;;
      *) print_error 'unrecognized option (choose number 1 or 2)' ;;
    esac
  done
fi

if [ -n "$name" ]; then
  dir=''
  old_version=''
  case "$name" in
    latest)
      dir='latest'
      old_version="$(jq -r ".${dir}[] | select(.imagemagick_legacy != true) | .imagemagick_version" <<< "$JSON" | head -n 1)"
      ;;
    legacy)
      dir='official'
      old_version="$(jq -r ".${dir}[] | select(.imagemagick_legacy == true) | .imagemagick_version" <<< "$JSON" | head -n 1)"
      ;;
  esac

  if [ -z "$new_version" ]; then
    echo "Current version: $old_version"
    read -rp "Enter new $name version: " new_version
    echo '---'
  fi

  summary "$dir" "$old_version" "$new_version"
  echo '---'
  replace "$dir" "$old_version" "$new_version"

  if [ "$FLAG_COMMIT" -eq 1 ]; then
    printf 'Committing...'
    git add \
      "$dir/alpine/Dockerfile" \
      "$dir/debian/Dockerfile" \
      DOCKERHUB.md \
      README.md \
      bin/bump-supported-tags.sh \
      versions.json
    if [ -n "$(git diff --cached --name-only)" ]; then
      printf '\n'
      echo '---'
      git commit -m "Bump ImageMagick from $old_version to $new_version"
    else
      printf ' Skipped\n'
    fi
  fi

  exit 0
fi
