    org 0x7C00
    section .text
    use16

%define SUPPORT_MODULE_BASE 0x0600

seg_setup:
    cli
    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov gs, ax
    mov fs, ax
    mov sp, SUPPORT_MODULE_BASE
    jmp 0:main

main:
    sti

    mov ah, 0x00
    mov al, 0x03
    int 0x10

    mov ah, 0x42
    mov si, dap
    int 0x13

    jc int_disk_ext_failure
    cmp word [dap.blkn], 1
    jne int_disk_ext_failure

    mov ah, 0x42
    mov bx, [SUPPORT_MODULE_BASE]
    mov [dap.blkn], bx
    int 0x13

    jc int_disk_ext_failure
    cmp [dap.blkn], bx
    jne int_disk_ext_failure

    call check_a20
    jne .a20_enabled
.enable_a20_bios:
    mov ax, 0x2401
    int 0x15

    call check_a20
    jne .a20_enabled
.enable_a20_kbd:
    in al, 0x92
    or al, 0x02
    out 0x92, al

    call check_a20
    je a20_failure
.a20_enabled:
    jmp 0x0602

error:
    mov ah, 0x13
    mov al, 0x01
    mov bh, 0x00
    mov bl, 0x07
    mov dh, 0x00
    mov dl, 0x00
    int 0x10

    cli
    hlt

int_disk_ext_failure:
    mov cx, int_disk_ext_failure_msg.len
    mov bp, int_disk_ext_failure_msg
    jmp error

a20_failure:
    mov cx, a20_failure_msg.len
    mov bp, a20_failure_msg
    jmp error

check_a20:
    mov ax, 0xFFFF
    mov ds, ax
    mov bx, [0x7E0E]
    xor ax, ax
    mov ds, ax
    cmp bx, [0x7DFE]

    ret


    section .data

dap:
.size db 0x10
.rsrv db 0x00
.blkn dw 0x0001
.offs dw SUPPORT_MODULE_BASE
.segm dw 0x0000
.slba dq 0x0001

int_disk_ext_failure_msg db "Extended INT 0x13 operation failed."
.len equ $ - int_disk_ext_failure_msg

a20_failure_msg db "Failed to enable the A20 line."
.len equ $ - a20_failure_msg
