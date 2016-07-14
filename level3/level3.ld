ENTRY(level3)

PHDRS {
  text PT_LOAD;
}

SECTIONS {
	. = 0x100000;

	.text BLOCK(4K) : ALIGN(4K) {
		*(.start)
		*(.text)
	} :text

	.rodata BLOCK(4K) : ALIGN(4K) {
		*(.rodata)
	} :text

	.data BLOCK(4K) : ALIGN(4K) {
		*(.data)
	} :text

	.bss BLOCK(4K) : ALIGN(4K) {
		*(COMMON)
		*(.bss)
	}
}
