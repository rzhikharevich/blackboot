    section .text
    use32

power_reset:
    cli

    in al, 0x02
    and al, 0x02
    jnz power_reset

    mov al, 0xFE
    out 0x64, al

    hlt

power_shutdown:
    ret
