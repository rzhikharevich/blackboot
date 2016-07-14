    section .text
    use32

keyboard_getch:
    mov edx, .rmode
    jmp morph_jmp16

    use16
.rmode:
    mov ah, 0x00
    int 0x16
    cmp al, 0x0D
    jne .not_cr
    mov al, 0x0A
.not_cr:
    and eax, 0xFF

    mov edx, .done
    jmp morph_jmp32

    use32
.done:
    ret
