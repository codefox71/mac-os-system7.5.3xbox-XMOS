#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: sudo ./scripts/write_image.sh IMAGE_FILE /dev/sdX

Write an image file to a removable storage device. This is intentionally kept
simple and requires root privileges. Use the destination device carefully; it
will be overwritten.
EOF
}

if [[ $# -lt 2 || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

IMAGE_FILE="$1"
DEST_DEVICE="$2"

if [[ ! -f "$IMAGE_FILE" ]]; then
  echo "Image not found: $IMAGE_FILE" >&2
  exit 1
fi

if [[ ! -b "$DEST_DEVICE" ]]; then
  echo "Destination is not a block device: $DEST_DEVICE" >&2
  exit 1
fi

if command -v sudo >/dev/null 2>&1; then
  SUDO="sudo"
else
  SUDO=""
fi

if [[ -n "$SUDO" ]]; then
  echo "Writing $IMAGE_FILE to $DEST_DEVICE"
  echo "This will overwrite the target device completely."
  read -r -p "Continue? [y/N] " CONFIRM
  if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "Aborted."
    exit 0
  fi
  $SUDO dd if="$IMAGE_FILE" of="$DEST_DEVICE" bs=4M status=progress conv=fsync
else
  dd if="$IMAGE_FILE" of="$DEST_DEVICE" bs=4M status=progress conv=fsync
fi

echo "Write complete."
