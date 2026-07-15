# mac OS System 7.5.3 Xbox 360 toolkit

This repository provides a small toolkit for preparing a disk image that may be used in homebrew experiments for booting Mac System 7.5.3 on an Xbox 360. The goal is to make the workflow safer and more repeatable without pretending that every combination of hardware and software will work.

## Important notes

- This is an experimental, community-oriented project. Success depends on your specific Xbox 360 hardware, bootloader, storage medium, and the image you use.
- Mouse and keyboard support may not work reliably, even if the system boots.
- For the image itself, use a reputable source or a dump you created yourself from media you legally own. Because this was freeware, prefer original or licensed copies over random internet downloads.
- Do not assume that every image or disk dump will work. A good workflow is to verify the image, test it in a safe environment, and only then move to hardware.

## What is included

- scripts/prepare_image.sh: copies a source image into a new working image and pads it to a target size.
- scripts/verify_image.sh: inspects the image type and size to catch obvious issues.
- scripts/write_image.sh: writes the prepared image to a removable device.

## Requirements

On Linux or macOS, you will typically want:

- bash
- coreutils
- file
- stat
- dd
- sudo (for writing to a device)

On Debian/Ubuntu, install the common utilities with:

```bash
sudo apt update
sudo apt install -y coreutils file util-linux
```

On macOS, install the Xcode command line tools if a utility is missing.

## Step 1: Obtain a source image

Use one of these options:

1. Dump an image from media you legally own.
2. Obtain a copy from a reputable source that clearly allows redistribution or is legally available to you.
3. Use a known-good System 7.5.3 image if you already have one from an old Macintosh emulator or archive.

Important: do not download random images from untrusted sites.

## Step 2: Prepare the image

Place the image in a local folder such as images/source and run:

```bash
mkdir -p output images/source
chmod +x scripts/*.sh
./scripts/prepare_image.sh ./images/source/mac753.img ./output/mac753-xbox.img 4096
```

The script will:

- copy the source image to the output path
- pad it to the requested size in megabytes
- create a SHA-256 manifest file

## Step 3: Verify the image

```bash
./scripts/verify_image.sh ./output/mac753-xbox.img
```

This checks the file type, size, and partition layout preview.

## Step 4: Write to removable media

Only do this once you have confirmed the destination device is correct.

```bash
sudo ./scripts/write_image.sh ./output/mac753-xbox.img /dev/sdX
```

Replace /dev/sdX with the actual block device for your USB drive or storage medium. Double-check the device name carefully.

## Step 5: Try it on the target hardware

The exact boot process will depend on the Xbox 360 homebrew environment you are using. In many cases this will involve:

- a compatible bootloader or exploit chain
- a storage device prepared for that launcher
- a carefully selected image format
- a lot of experimentation

If you are using the image for research or hobby purposes, keep notes about what worked and what did not.

## Troubleshooting

- If the image is too small, the target may fail to mount or boot.
- If the image is not recognized, try a different source image or a different format.
- If the system boots but input fails, input compatibility is likely the limiting factor.
- If the device write fails, confirm that the destination is the correct drive and that you have permission to write to it.

## Safety and legality

- Always respect device ownership and local laws.
- Only use software and images that you are permitted to use.
- Be mindful that writing to a device can destroy data.

## License

This repository is released under the MIT license. See LICENSE for details.
