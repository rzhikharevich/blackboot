    section .data

struc ELFHeader
.magic resd 1
.class resb 1
.order resb 1
.vers1 resb 1
.rsrv1 resb 9
.type  resw 1
.mach  resw 1
.vers2 resd 1
.entry resd 1
.phoff resd 1
.shoff resd 1
.flags resd 1
.hdrsz resw 1
.phesz resw 1
.phnum resw 1
.shesz resw 1
.shnum resw 1
.strdx resw 1
endstruc

%define ELF_MAGIC        0x464C457F
%define ELF_CLASS_32     1
%define ELF_ORDER_LITTLE 1
%define ELF_VER_CURRENT  1
%define ELF_TYPE_EXEC    2
%define ELF_MACHINE_X86  3

struc ELFProgramHeader
.type  resd 1
.offs  resd 1
.vaddr resd 1
.paddr resd 1
.fsize resd 1
.msize resd 1
.flags resd 1
.align resd 1
endstruc
