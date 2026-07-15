import tempfile
import unittest
from pathlib import Path

from tiny68k.emulator import Tiny68kEmulator


class Tiny68kEmulatorTests(unittest.TestCase):
    def test_boot_sequence_initializes_video_and_marks_ready(self):
        emu = Tiny68kEmulator()
        emu.load_program(
            [
                ("moveq", 1, "d0"),
                ("call", "video.init"),
                ("call", "video.draw_boot_banner", "Mac System 7.5.3"),
                ("call", "keyboard.init"),
                ("halt",),
            ]
        )

        status = emu.run()

        self.assertEqual(status, "booted")
        self.assertTrue(emu.video.initialized)
        self.assertTrue(emu.keyboard.initialized)
        self.assertIn("BOOT", emu.video.render_text().upper())

    def test_load_image_bytes_into_memory(self):
        emu = Tiny68kEmulator()

        with tempfile.TemporaryDirectory() as tmpdir:
            image_path = Path(tmpdir) / "sample.img"
            image_path.write_bytes(b"\x00\x01\x02")
            emu.load_image(image_path)

        self.assertEqual(emu.memory[0x4000:0x4003], b"\x00\x01\x02")


if __name__ == "__main__":
    unittest.main()
