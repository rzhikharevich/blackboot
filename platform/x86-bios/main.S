%define PLATFORM_MODULE_SIZE 3
%include "memory_macros.S"
%include "elf.S"
%include "vbe.S"

    org 0x0600
    section .text
    use16

dw PLATFORM_MODULE_SIZE ; Size of this platform support module in 512-byte blocks.

setup:
    mov [platform_table.storage_boot_n], dl
    mov [level3_addr], dl

    mov ah, 0x00
    mov al, 0x13
    int 0x10

    mov ax, 0x4F00
    mov di, 0x6000
    mov dword [di], "VBE2"
    int 0x10
    cmp ax, 0x004F
    jne .no_vbe

    cmp dword [di], "VESA"
    jne .no_vbe

    cmp word [di + VBEInfo.version], 0x0200
    jb .no_vbe

    mov fs, [di + VBEInfo.vmodes + 2]
    mov si, [di + VBEInfo.vmodes]
    mov ax, [fs:si]
    xor edx, edx
    xor bx, bx
.vbe_lp:
    mov ax, 0x4F01
    mov di, 0x6200
    mov cx, [fs:si]
    cmp cx, 0xFFFF
    je .vbe_fin
    int 0x10
    cmp ax, 0x004F
    jne .no_vbe

    add si, 2

    cmp edx, [di + VBEModeInfo.x_res]
    jnb .vbe_lp
    test byte [di + VBEModeInfo.attr], 1 << 4
    jz .vbe_lp
    test byte [di + VBEModeInfo.attr], 1 << 7
    jz .vbe_lp
    cmp dword [di + VBEModeInfo.fb], 0
    je .vbe_lp
    mov edx, [di + VBEModeInfo.x_res]
    mov bx, cx
    jmp .vbe_lp
.vbe_fin:
    or bx, 1 << 14
    mov ax, 0x4F02
    int 0x10
    cmp ax, 0x004F
    jne .no_vbe

    mov ax, 0x4F01
    mov cx, bx
    int 0x10
    cmp ax, 0x004F
    jne .no_vbe

    mov byte [video_info.fmt], 1
    mov [video_info.w], edx
    mov eax, [di + VBEModeInfo.fb]
    mov [video_info.fb], eax
    mov al, [di + VBEModeInfo.pix_bits]
    mov [video_info.bpp], al
    mov si, di
    add si, VBEModeInfo.red_pos
    mov di, video_info.r_p
    mov cx, 3
    rep movsw
.no_vbe:
    xor ax, ax
    mov fs, ax

    mov ax, 0x1130
    mov bh, 0x0006
    int 0x10

    push es
    pop ds
    xor ax, ax
    mov es, ax
    mov si, bp
    mov di, 0x6000
    mov cx, 0x0400
    rep movsd
    mov ds, ax

    memory_get_largest ; ECX = largest memory block

    mov edx, main
    jmp morph_jmp32


    section .text
    use32
main:
    push ecx

    mov edx, level3_addr
    call storage_read
    test eax, eax
    jnz level3_load_failure

    mov ecx, [esp]

    mov eax, [ecx]
    cmp eax, ELF_MAGIC
    jne level3_corrupt

    mov eax, [ecx + ELFHeader.class]
    cmp al, ELF_CLASS_32
    jne level3_corrupt

    shr eax, 8
    cmp al, ELF_ORDER_LITTLE
    jne level3_corrupt

    shr eax, 8
    cmp al, ELF_VER_CURRENT
    jne level3_corrupt

    mov eax, [ecx + ELFHeader.type]
    cmp ax, ELF_TYPE_EXEC
    jne level3_corrupt

    shr eax, 16
    cmp ax, ELF_MACHINE_X86
    jne level3_corrupt

    mov eax, [ecx + ELFHeader.vers2]
    cmp eax, ELF_VER_CURRENT
    jne level3_corrupt

    mov edi, [ecx + ELFHeader.entry]

    add ecx, [ecx + ELFHeader.phoff]

    mov eax, [ecx + ELFProgramHeader.offs]
    xor edx, edx
    mov ebx, 512
    div ebx
    test edx, edx
    jnz level3_corrupt
    add [level3_addr + 5], eax

    mov eax, [ecx + ELFProgramHeader.fsize]
    xor edx, edx
    mov ebx, 512
    div ebx
    test edx, edx
    jz .load
    inc eax
.load:
    mov [level3_addr + 1], eax

    mov dword [platform_table.storage_read], storage_read ; workaround

    mov ebx, [ecx + ELFProgramHeader.msize]
    pop ecx
    add ebx, ecx
    mov edx, level3_addr
    call storage_read
    test eax, eax
    jnz level3_load_failure

    mov ecx, platform_table
    mov edx, ebx
    jmp edi

level3_load_failure:
    mov cx, level3_load_failure_msg_len
    mov bp, level3_load_failure_msg
    jmp error

level3_corrupt:
    mov cx, level3_corrupt_msg_len
    mov bp, level3_corrupt_msg
    jmp error


    section .data

level3_addr:
db 0x80
dd 0x01
dq 1 + PLATFORM_MODULE_SIZE

level3_load_failure_msg     db "Failed to load the 3rd level module."
level3_load_failure_msg_len equ $ - level3_load_failure_msg

level3_corrupt_msg     db "The 3rd level module is corrupt."
level3_corrupt_msg_len equ $ - level3_corrupt_msg


%include "morph.S"
%include "error.S"
%include "video.S"
%include "storage.S"
%include "power.S"
%include "keyboard.S"
%include "table.S"
