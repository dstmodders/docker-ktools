#!/usr/bin/env bash
#
# Shared helpers for the scripts in this directory.
#
# Source this file after BASE_DIR is defined:
#   source "${BASE_DIR}/common.sh"
#
usage() {
  awk '
    NR==1 && /^#!/ { next }
    /^#/ {
      sub(/^# ?/, "")
      buf = buf ? buf ORS $0 : $0
      next
    }
    buf { exit }
    END {
      if (buf) {
        sub(/[[:space:]]+$/, "", buf)
        print buf
      }
    }
  ' "$0"
}

print_bold_color() {
  local color="$1"
  local value="$2"
  local output="${3:-1}"

  if [ "${NO_COLOR}" = '1' ] || ! [ -t "${output}" ]; then
    printf '%s' "${value}" >&"${output}"
  else
    printf "$(tput bold)$(tput setaf "${color}")%s$(tput sgr0)" "${value}" >&"${output}"
  fi
}

print_error() {
  local message="$1"
  print_bold_color 1 "error: ${message}" 2
  printf '\n' >&2
}

die() {
  local message="$1"
  print_error "${message}"
  exit 1
}

print_separator() {
  print_bold_color 0 '---'
  printf '\n'
}

complete() {
  local color="$1"
  local message="$2"
  print_separator
  print_bold_color "${color}" "${message}"
  printf '\n'
  exit 0
}

# shellcheck disable=SC2329
interrupt() {
  printf '\n'
  print_separator
  print_bold_color 1 'Interrupted'
  printf '\n'
  exit 130
}

print_step() {
  local message="$1"
  local value="${2:-}"

  printf -- '--> %s' "${message}"
  if [ -n "${value}" ]; then
    printf ': '
    print_bold_color 7 "${value}"
  fi
}

print_step_dotted() {
  local message="$1"
  local value="${2:-}"

  print_step "${message}" "${value}"
  printf '... '
}

print_step_success() {
  local value="${1:-Success}"
  print_bold_color 2 "${value}"
  printf '\n'
}

print_step_skipped() {
  local value="${1:-Skipped}"
  print_bold_color 3 "${value}"
  printf '\n'
}
