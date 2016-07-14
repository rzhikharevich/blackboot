all: build


build: mbr.bin

mbr.bin: mbr.S
	$(YASM) -f bin mbr.S -o mbr.bin

flash:
	dd if=mbr.bin of=$(BOOT_IMAGE) conv=notrunc
