OBJS = $(patsubst %.c,%.o,$(shell find . -name '*.c'))


all: build


build: level3.elf

level3.elf: $(OBJS) *.h
	$(LD) $(LDFLAGS) -Tlevel3.ld $(OBJS) -o $@


flash:
	dd if=level3.elf of=$(BOOT_IMAGE) conv=notrunc bs=512 seek=4
