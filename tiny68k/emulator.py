"""A tiny 68k-inspired emulator scaffold for boot experiments."""

from __future__ import annotations

from pathlib import Path
from typing import Any, List, Tuple


class VideoDriver:
    """Minimal video driver used by the boot stub."""

    def __init__(self) -> None:
        self.initialized = False
        self.framebuffer: List[str] = []

    def init(self) -> None:
        self.initialized = True
        self.framebuffer = ["VIDEO READY"]

    def draw_boot_banner(self, text: str) -> None:
        self.framebuffer.append(f"BOOT: {text}")

    def render_text(self) -> str:
        return "\n".join(self.framebuffer) if self.framebuffer else "BOOT"


class Tiny68kEmulator:
    """A very small emulator that can load an image and run a boot program."""

    def __init__(self) -> None:
        self.memory = bytearray(1024 * 1024)
        self.registers: dict[str, int] = {"d0": 0, "d1": 0, "a0": 0x4000}
        self.program: List[Tuple[Any, ...]] = []
        self.video = VideoDriver()
        self.status = "idle"
        self.last_message = ""

    def load_program(self, instructions: List[Tuple[Any, ...]]) -> None:
        self.program = list(instructions)

    def load_image(self, image_path: str | Path) -> None:
        path = Path(image_path)
        data = path.read_bytes()
        self.memory[0x4000 : 0x4000 + len(data)] = data
        self.last_message = f"loaded {len(data)} bytes from {path.name}"

    def run(self) -> str:
        for instruction in self.program:
            opcode = instruction[0]
            if opcode == "moveq":
                self.registers["d0"] = int(instruction[1])
            elif opcode == "call":
                target = instruction[1]
                if target == "video.init":
                    self.video.init()
                elif target == "video.draw_boot_banner":
                    text = instruction[2] if len(instruction) > 2 else "Mac System 7.5.3"
                    self.video.draw_boot_banner(str(text))
                else:
                    self.last_message = f"unknown target: {target}"
            elif opcode == "halt":
                break

        if self.video.initialized and self.video.render_text():
            self.status = "booted"
            self.last_message = "booted with video driver"
        return self.status

    def boot(self, image_path: str | Path) -> str:
        self.load_image(image_path)
        self.load_program(
            [
                ("moveq", 1, "d0"),
                ("call", "video.init"),
                ("call", "video.draw_boot_banner", "Mac System 7.5.3"),
                ("halt",),
            ]
        )
        return self.run()
