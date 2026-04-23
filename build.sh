#!/bin/bash
set -e

echo "[*] Assembling bootloader..."
nasm boot/boot.asm -f bin -o build/bin/boot.bin

echo "[*] Assembling stage2..."
nasm boot/stage2.asm -f bin -o build/bin/stage2.bin

echo "[*] Creating 10MB disk image..."
dd if=/dev/zero of=build/image/os.img bs=1M count=10 status=none

dd if=build/bin/boot.bin of=build/image/os.img conv=notrunc bs=512 seek=0 status=none

dd if=build/bin/stage2.bin of=build/image/os.img conv=notrunc bs=512 seek=1 status=none

echo "[✓] Build complete"
echo "[*] Running in QEMU..."
qemu-system-x86_64 -hda build/image/os.img -boot c
