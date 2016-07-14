    section .text
    use32

error:
    mov dx, .rmode
    jmp morph_jmp16

    use16
.rmode:
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    mov ah, 0x13
    mov al, 0x01
    mov bh, 0x00
    mov bl, 0x07
    mov dh, 0x00
    mov dl, 0x00
    int 0x10

    cli
    hlt
