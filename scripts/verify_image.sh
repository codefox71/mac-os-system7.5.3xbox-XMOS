#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./scripts/verify_image.sh IMAGE_FILE

Inspect an image file to ensure it looks like a disk image that can be used for
experimentation with homebrew Xbox 360 booting.
EOF
}

if [[ $# -lt 1 || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

IMAGE_FILE="$1"

if [[ ! -f "$IMAGE_FILE" ]]; then
  echo "Image not found: $IMAGE_FILE" >&2
  exit 1
fi

FILE_TYPE="$(file -b "$IMAGE_FILE" || true)"
SIZE_BYTES="$(stat -c '%s' "$IMAGE_FILE" 2>/dev/null || stat -f '%z' "$IMAGE_FILE" 2>/dev/null || echo 'unknown')"
SIZE_MB=$(( SIZE_BYTES / 1024 / 1024 ))

printf 'File: %s\n' "$IMAGE_FILE"
printf 'Type: %s\n' "$FILE_TYPE"
printf 'Size: %s bytes (%s MB)\n' "$SIZE_BYTES" "$SIZE_MB"

if [[ "$FILE_TYPE" == *"DOS/MBR"* ]] || [[ "$FILE_TYPE" == *"ISO"* ]] || [[ "$FILE_TYPE" == *"x86 boot sector"* ]] || [[ "$FILE_TYPE" == *"disk image"* ]]; then
  echo "Image format looks plausible for a disk image."
else
  echo "Image type is not clearly a disk image; double-check the source."
fi

if command -v fdisk >/dev/null 2>&1; then
  echo "Partition table preview:"
  fdisk -l "$IMAGE_FILE" 2>/dev/null || true
fi

echo "Verification complete."
