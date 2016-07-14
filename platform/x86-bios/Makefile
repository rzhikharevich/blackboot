all: build


build: platform.bin

platform.bin: *.S
	$(YASM) -f bin main.S -o platform.bin


flash:
	dd if=platform.bin of=$(BOOT_IMAGE) conv=notrunc bs=512 seek=1
