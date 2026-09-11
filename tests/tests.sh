#!/usr/bin/env sh

# define constants
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR='./result'
SRC_DIR='./src'
KRANE_OUTPUT_DIR="${OUTPUT_DIR}/chester"
KRANE_SRC_DIR="${SRC_DIR}/chester"
KTECH_SRC_FILENAME='minimap_atlas'
KTECH_SRC_PNG="${SRC_DIR}/${KTECH_SRC_FILENAME}.png"
KTECH_SRC_TEX="${SRC_DIR}/${KTECH_SRC_FILENAME}.tex"
KTECH_TRANSPARENCY_FILENAME='transparency_test'
KTECH_TRANSPARENCY_PNG="${SRC_DIR}/${KTECH_TRANSPARENCY_FILENAME}.png"

readonly BASE_DIR
readonly KRANE_OUTPUT_DIR
readonly KRANE_SRC_DIR
readonly KTECH_SRC_FILENAME
readonly KTECH_SRC_PNG
readonly KTECH_SRC_TEX
readonly KTECH_TRANSPARENCY_FILENAME
readonly KTECH_TRANSPARENCY_PNG
readonly OUTPUT_DIR
readonly SRC_DIR

print_bold_color() {
  color="$1"
  value="$2"
  output="${3:-1}"

  if [ "${NO_COLOR}" = '1' ] || ! [ -t "${output}" ]; then
    printf '%s' "${value}" >&"${output}"
  else
    printf "\033[1;3%sm%s\033[0m" "${color}" "${value}" >&"${output}"
  fi
}

print_error() {
  message="$1"
  print_bold_color 1 "error: ${message}" 2
  printf '\n' >&2
}

die() {
  message="$1"
  print_error "${message}"
  exit 1
}

print_step() {
  message="$1"
  value="${2:-}"

  printf -- '--> %s' "${message}"
  if [ -n "${value}" ]; then
    printf ': '
    print_bold_color 7 "${value}"
  fi
}

print_step_dotted() {
  message="$1"
  value="${2:-}"

  print_step "${message}" "${value}"
  printf '... '
}

print_step_success() {
  value="${1:-Success}"
  print_bold_color 2 "${value}"
  printf '\n'
}

is_installed() {
  cmd="$1"
  command -v "${cmd}" > /dev/null
}

print_title() {
  title="$1"
  printf '\n%s:\n\n' "${title}"
}

run_png_to_tex_compression() {
  src="$1"
  compression="$2"
  printf '\nPNG => TEX (%s):\n\n' "${compression}"
  ktech \
    --verbose \
    --compression "${compression}" \
    "${src}" \
    "${OUTPUT_DIR}/minimap_atlas_${compression}.tex"
}

run_png_to_tex_filter() {
  src="$1"
  filter="$2"
  printf '\nPNG => TEX (%s):\n\n' "${filter}"
  ktech \
    --verbose \
    --filter "${filter}" \
    --height 512 \
    --width 512 \
    "${src}" \
    "${OUTPUT_DIR}/minimap_atlas_${filter}.tex"
}

run_png_from_generated_tex() {
  to="$1"
  name="$2"
  ktech "${OUTPUT_DIR}/${name}.tex" "${to}/${name}.tex.png"
}

cd "${BASE_DIR}" || exit 1

if ! is_installed 'krane'; then
  die 'krane is not installed'
fi

if ! is_installed 'ktech'; then
  die 'ktech is not installed'
fi

# prepare
rm -rf "${OUTPUT_DIR}"
mkdir "${OUTPUT_DIR}"

# ktech
print_step_dotted 'Generating ktech output'
{
  # TEX => PNG
  printf 'TEX info:\n\n'
  ktech --verbose --info "${KTECH_SRC_TEX}"

  print_title 'TEX => PNG (default)'
  ktech --verbose "${KTECH_SRC_TEX}" "${OUTPUT_DIR}"

  print_title 'TEX => PNG (quality)'
  ktech \
    --verbose \
    --quality 10 \
    "${KTECH_SRC_TEX}" \
    "${OUTPUT_DIR}/${KTECH_SRC_FILENAME}_quality-10.png"

  print_title 'TEX => PNG (resize)'
  ktech \
    --verbose \
    --height 512 \
    --width 512 \
    "${KTECH_SRC_TEX}" \
    "${OUTPUT_DIR}/${KTECH_SRC_FILENAME}_512x512.png"

  print_title 'TEX => PNG (extend)'
  ktech \
    --verbose \
    --height 512 \
    --width 512 \
    --extend \
    "${KTECH_SRC_TEX}" \
    "${OUTPUT_DIR}/${KTECH_SRC_FILENAME}_512x512_extend.png"

  # PNG => TEX
  print_title 'PNG => TEX (default)'
  ktech --verbose "${KTECH_SRC_PNG}" "${OUTPUT_DIR}"

  print_title 'PNG => TEX (atlas)'
  ktech \
    --verbose \
    --atlas "${OUTPUT_DIR}/${KTECH_SRC_FILENAME}_atlas.xml" \
    "${KTECH_SRC_PNG}" \
    "${OUTPUT_DIR}/${KTECH_SRC_FILENAME}_atlas.tex"

  # compression
  run_png_to_tex_compression "${KTECH_SRC_PNG}" 'dxt1'
  run_png_to_tex_compression "${KTECH_SRC_PNG}" 'dxt3'
  run_png_to_tex_compression "${KTECH_SRC_PNG}" 'dxt5'
  run_png_to_tex_compression "${KTECH_SRC_PNG}" 'rgb'
  run_png_to_tex_compression "${KTECH_SRC_PNG}" 'rgba'

  # filter
  run_png_to_tex_filter "${KTECH_SRC_PNG}" 'bicubic'
  run_png_to_tex_filter "${KTECH_SRC_PNG}" 'box'
  run_png_to_tex_filter "${KTECH_SRC_PNG}" 'catrom'
  run_png_to_tex_filter "${KTECH_SRC_PNG}" 'cubic'
  run_png_to_tex_filter "${KTECH_SRC_PNG}" 'lanczos'
  run_png_to_tex_filter "${KTECH_SRC_PNG}" 'mitchell'

  # transparency test
  print_title 'PNG => TEX (transparency test)'
  ktech \
    --verbose \
    "${KTECH_TRANSPARENCY_PNG}" \
    "${OUTPUT_DIR}/${KTECH_TRANSPARENCY_FILENAME}.tex"

  print_title 'PNG => TEX (transparency test with no-premultiply)'
  ktech \
    --verbose \
    --no-premultiply \
    "${KTECH_TRANSPARENCY_PNG}" \
    "${OUTPUT_DIR}/${KTECH_TRANSPARENCY_FILENAME}_no-premultiply.tex"
} > "${OUTPUT_DIR}/log.txt" 2>&1
print_step_success

# krane
print_step_dotted 'Generating krane output'
{
  print_title 'krane (default)'
  krane --verbose "${KRANE_SRC_DIR}" "${KRANE_OUTPUT_DIR}"

  print_title 'krane (mark-atlases)'
  krane \
    --verbose \
    --mark-atlases \
    "${KRANE_SRC_DIR}" \
    "${KRANE_OUTPUT_DIR}_mark-atlases"

  print_title 'krane (bank)'
  krane \
    --verbose \
    --bank chester \
    "${KRANE_SRC_DIR}" \
    "${KRANE_OUTPUT_DIR}_bank"

  print_title 'krane (rename)'
  krane \
    --verbose \
    --rename-bank chester_renamed \
    --rename-build chester_build_renamed \
    "${KRANE_SRC_DIR}" \
    "${KRANE_OUTPUT_DIR}_rename"
} >> "${OUTPUT_DIR}/log.txt" 2>&1
print_step_success

# create PNGs from generated TEXs
print_step_dotted 'Generating PNGs from generated TEXs'
{
  run_png_from_generated_tex "${OUTPUT_DIR}" "${KTECH_SRC_FILENAME}"
  run_png_from_generated_tex "${OUTPUT_DIR}" "${KTECH_SRC_FILENAME}_atlas"

  # compression
  run_png_from_generated_tex "${OUTPUT_DIR}" "${KTECH_SRC_FILENAME}_dxt1"
  run_png_from_generated_tex "${OUTPUT_DIR}" "${KTECH_SRC_FILENAME}_dxt3"
  run_png_from_generated_tex "${OUTPUT_DIR}" "${KTECH_SRC_FILENAME}_dxt5"
  run_png_from_generated_tex "${OUTPUT_DIR}" "${KTECH_SRC_FILENAME}_rgb"
  run_png_from_generated_tex "${OUTPUT_DIR}" "${KTECH_SRC_FILENAME}_rgba"

  # filter
  run_png_from_generated_tex "${OUTPUT_DIR}" "${KTECH_SRC_FILENAME}_bicubic"
  run_png_from_generated_tex "${OUTPUT_DIR}" "${KTECH_SRC_FILENAME}_box"
  run_png_from_generated_tex "${OUTPUT_DIR}" "${KTECH_SRC_FILENAME}_catrom"
  run_png_from_generated_tex "${OUTPUT_DIR}" "${KTECH_SRC_FILENAME}_cubic"
  run_png_from_generated_tex "${OUTPUT_DIR}" "${KTECH_SRC_FILENAME}_lanczos"
  run_png_from_generated_tex "${OUTPUT_DIR}" "${KTECH_SRC_FILENAME}_mitchell"

  # transparency
  run_png_from_generated_tex "${OUTPUT_DIR}" "${KTECH_TRANSPARENCY_FILENAME}"
  run_png_from_generated_tex \
    "${OUTPUT_DIR}" \
    "${KTECH_TRANSPARENCY_FILENAME}_no-premultiply"
} > /dev/null 2>&1
print_step_success
