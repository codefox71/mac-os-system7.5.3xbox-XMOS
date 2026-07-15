#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./scripts/prepare_image.sh SOURCE_IMAGE [OUTPUT_IMAGE] [SIZE_MB]

Create a working disk image from an existing Mac System 7.5.3 image or disk dump.
The script copies the source image to OUTPUT_IMAGE and pads it to the requested
size in megabytes (default: 2048 MB). This is useful for experimenting with Xbox
360 homebrew loaders that expect a larger storage image.

Examples:
  ./scripts/prepare_image.sh ./images/source/mac753.img
  ./scripts/prepare_image.sh ./images/source/mac753.iso ./output/mac753-xbox.img 4096
EOF
}

if [[ $# -lt 1 || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

SOURCE_IMAGE="$1"
OUTPUT_IMAGE="${2:-./output/mac-system7.5.3-xbox360.img}"
SIZE_MB="${3:-2048}"

if [[ ! -f "$SOURCE_IMAGE" ]]; then
  echo "Source image not found: $SOURCE_IMAGE" >&2
  exit 1
fi

if [[ "$OUTPUT_IMAGE" == "$SOURCE_IMAGE" ]]; then
  echo "Output image must be different from the source image." >&2
  exit 1
fi

mkdir -p "$(dirname "$OUTPUT_IMAGE")"

SOURCE_SIZE_BYTES=""
if command -v stat >/dev/null 2>&1; then
  if stat -c '%s' "$SOURCE_IMAGE" >/dev/null 2>&1; then
    SOURCE_SIZE_BYTES="$(stat -c '%s' "$SOURCE_IMAGE")"
  else
    SOURCE_SIZE_BYTES="$(stat -f '%z' "$SOURCE_IMAGE")"
  fi
fi

if [[ -z "$SOURCE_SIZE_BYTES" ]]; then
  echo "Unable to determine the source image size." >&2
  exit 1
fi

cp -f "$SOURCE_IMAGE" "$OUTPUT_IMAGE"

TARGET_SIZE_BYTES=$(( SIZE_MB * 1024 * 1024 ))
if (( SOURCE_SIZE_BYTES > TARGET_SIZE_BYTES )); then
  echo "Source image is larger than the requested target size; leaving the current size intact."
else
  truncate -s "$TARGET_SIZE_BYTES" "$OUTPUT_IMAGE"
fi

if command -v sha256sum >/dev/null 2>&1; then
  sha256sum "$OUTPUT_IMAGE" > "$OUTPUT_IMAGE.sha256"
elif command -v shasum >/dev/null 2>&1; then
  shasum -a 256 "$OUTPUT_IMAGE" > "$OUTPUT_IMAGE.sha256"
else
  echo "Warning: no checksum tool found; skipped manifest creation." >&2
fi

echo "Prepared image: $OUTPUT_IMAGE"
echo "SHA256 manifest: $OUTPUT_IMAGE.sha256"
echo "Next step: ./scripts/verify_image.sh $OUTPUT_IMAGE"
echo "To write it to removable media, use: sudo ./scripts/write_image.sh $OUTPUT_IMAGE /dev/sdX"
