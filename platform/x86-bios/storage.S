%define DRIVE_REMOVABLE (1 << 2)

    section .text
    use32

storage_get_info:
    push esi

    mov al, dl
    mov dx, .rmode
    jmp morph_jmp16

    use16
.rmode:
    mov ah, 0x48
    mov dl, al
    mov si, drv_param_buff
    mov word [si + DriveParams.size], 0x1A
    int 0x13

    mov eax, 1
    jc .rmode_ret
    mov al, 0
.rmode_ret:
    mov edx, .pmode
    jmp morph_jmp32

    use32
.pmode:
    cmp al, 1
    je .done

    mov edx, [drv_param_buff + DriveParams.sectn]
    mov [ecx + StorageInfo.sectn], edx
    mov edx, [drv_param_buff + DriveParams.sectn + 4]
    mov [ecx + StorageInfo.sectn + 4], edx

    mov dx, [drv_param_buff + DriveParams.sectsz]
    mov [ecx + StorageInfo.sectsz], dx

    mov dx, [drv_param_buff + DriveParams.flags]
    and dx, DRIVE_REMOVABLE
    mov byte [ecx + StorageInfo.removb], 1
    jz .done
    mov byte [ecx + StorageInfo.removb], 0
.done:
    and eax, 0xFF
    pop esi

    ret

storage_read:
    push edi
    push esi

    mov edi, ecx

    mov cx, 0x10
    mov [dap_buff + DiskAddrPacket.size], cx

    mov ecx, 0x7E00
    mov [dap_buff + DiskAddrPacket.offs], ecx

    mov al, [edx + StorageAddrPack.drvn]

    mov ecx, [edx + StorageAddrPack.blkn]
    mov [dap_buff + DiskAddrPacket.blkn], cx

    mov ecx, [edx + StorageAddrPack.slba]
    mov [dap_buff + DiskAddrPacket.slba], ecx
    mov ecx, [edx + StorageAddrPack.slba + 4]
    mov [dap_buff + DiskAddrPacket.slba + 4], ecx

    mov dx, .rmode
    jmp morph_jmp16

    use16
.rmode:
    mov ah, 0x42
    mov dl, al
    mov si, dap_buff
    int 0x13

    mov al, 1
    jc .rmode_ret
    mov al, 0
.rmode_ret:
    mov edx, .cpy
    jmp morph_jmp32

    use32
.cpy:
    and eax, 0xFF
    jnz .done

    mov esi, 0x7E00
    mov ax, [dap_buff + DiskAddrPacket.blkn]
    mov dx, 512
    mul dx
    mov cx, dx
    shl cx, 16
    mov cx, ax
    cld
    rep movsb

    xor eax, eax
.done:
    pop esi
    pop edi

    ret


    section .data

struc DriveParams
; 1.x
.size   resw 1
.flags  resw 1
.cyln   resd 1
.headn  resd 1
.secpt  resd 1
.sectn  resq 1
.sectsz resw 1
; 2.x
.cfgoff resw 1
.cfgseg resw 1
; 3.x
.magic  resw 1
.devpln resb 1
.rsrv0  resb 1
.hostb  resb 4
.interf resb 8
.ifpath resb 8
.devp   resb 8
.rsrv1  resb 1
.chksum resb 1
endstruc

drv_param_buff equ 0x7C00

struc StorageInfo
.sectn  resq 1
.sectsz resw 2
.removb resb 1
endstruc

struc DiskAddrPacket
.size resb 1
.rsrv resb 1
.blkn resw 1
.offs resw 1
.segm resw 1
.slba resq 1
endstruc

dap_buff equ 0x7C00

struc StorageAddrPack
.drvn resb 1
.blkn resd 1
.slba resq 1
endstruc
