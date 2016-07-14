    section .text
    use16

morph_jmp32:
    mov [stack16], sp
    push eax

    mov ax, 0xCF
    mov [gdt.code + 6], ax
    mov [gdt.data + 6], ax

    cli
    lgdt [gdtr]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp 0x08:.pmode

    use32
.pmode:
    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov gs, ax
    mov fs, ax

    pop eax
    mov esp, [stack32]
    jmp edx

morph_jmp16:
    mov [stack32], esp
    push eax

    mov ax, 0x8F
    mov [gdt.code + 6], ax
    mov [gdt.data + 6], ax

    cli
    lgdt [gdtr]
    jmp 0x08:.pmode16

    use16
.pmode16:
    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov gs, ax
    mov fs, ax

    lidt [idtr16]
    mov eax, cr0
    and eax, ~1
    mov cr0, eax
    jmp 0x00:.rmode
.rmode:
    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov gs, ax
    mov fs, ax

    pop eax
    mov sp, [stack16]
    sti
    jmp dx

morph_memcpy32:
    push edx

    mov edx, .pmode
    jmp morph_jmp32
.pmode:
    rep movsb

    mov dx, .done
    jmp morph_jmp16

    use16
.done:
    pop edx

    ret


    section .data

gdt:
.null dq 0
.code:
dw 0xFFFF ; Limit (low 16 bits).
dw 0x0000 ; Base (low 16 bits).
db 0x00   ; Base (mid 8 bits).
db 0x9A   ; Access: present, executable, readable.
db 0xCF   ; Flags: limit is in 4 KiB blocks, 32-bit. Limit (bits 16-19)
db 0x00   ; Base (high 8 bits).
.data:
dw 0xFFFF ; Limits (low 16 bits).
dw 0x0000 ; Base (low 16 bits).
db 0x00   ; Base (mid 8 bits).
db 0x92   ; Access: present, writable.
db 0xCF   ; Flags: limit is in 4 KiB blocks, 32-bit. Limit (bits 16-19)
db 0x00   ; Base (high 8 bits).
gdtr:
.size dw 0x0017
.offs dd gdt

idtr16:
.size dw 0x03FF
.offs dd 0x0000

stack16 dw 0x0600
stack32 dd 0x7C00
