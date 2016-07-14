ARCH        = i386
BITS        = 32
TARGET      = x86-bios
BOOT_IMAGE  = $(shell pwd)/boot.img

CC      = clang
CFLAGS  = --target=$(ARCH)-pc-none-elf -ffreestanding
LD      = $(ARCH)-elf-ld
LDFLAGS = --format elf$(BITS)-$(ARCH) --oformat elf$(BITS)-$(ARCH) -m elf_$(ARCH)
YASM    = yasm
QEMU    = qemu-system-$(ARCH)


all: build


build: loader platform level3

.PHONY: loader platform level3

loader:
	cd loader/$(TARGET) && make build YASM=$(YASM)

platform:
	cd platform/$(TARGET) && make build YASM=$(YASM)

level3:
	cd level3 && make build CC=$(CC) CFLAGS="$(CFLAGS)" LD=$(LD) LDFLAGS="$(LDFLAGS)"


flash:
	cd loader/$(TARGET) && make flash BOOT_IMAGE=$(BOOT_IMAGE)
	cd platform/$(TARGET) && make flash BOOT_IMAGE=$(BOOT_IMAGE)
	cd level3 && make flash BOOT_IMAGE=$(BOOT_IMAGE)

run: flash
	$(QEMU) -monitor stdio -hda $(BOOT_IMAGE)
