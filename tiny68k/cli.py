#!/usr/bin/env python3
"""Command-line entry point for the tiny 68k boot simulator."""

from __future__ import annotations

import argparse
from pathlib import Path

from .emulator import Tiny68kEmulator


def main() -> int:
    parser = argparse.ArgumentParser(description="Boot a disk image through a tiny 68k-style stub")
    parser.add_argument("image", type=Path, help="Path to an image file to load")
    args = parser.parse_args()

    emulator = Tiny68kEmulator()
    status = emulator.boot(args.image)
    print(f"status={status}")
    print(emulator.video.render_text())
    return 0 if status == "booted" else 1


if __name__ == "__main__":
    raise SystemExit(main())
