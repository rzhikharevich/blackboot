    section .text
    use16

%macro memory_get_largest 0
    xor ebx, ebx
    mov di, mmap_buff
    xor esi, esi
    mov dword [mmap_last_size], 0
    mov dword [mmap_last_size + 4], 0
.__mmap_srch_lp:
    mov eax, 0xE820
    mov ecx, 0x14
    mov edx, 'PAMS'
    int 0x15

    jc .__mmap_srch_done

    test ebx, ebx
    jz .__mmap_srch_done

    cmp dword [mmap_buff + MemDesc.type], 1
    jne .__mmap_srch_lp

    mov eax, [mmap_buff + MemDesc.size + 4]
    cmp eax, [mmap_last_size + 4]
    jb .__mmap_srch_lp
    ja .__mmap_srch_bigger

    mov ecx, [mmap_buff + MemDesc.size]
    cmp ecx, [mmap_last_size]
    jna .__mmap_srch_lp
.__mmap_srch_bigger:
    mov esi, [mmap_buff + MemDesc.base]
    mov [mmap_last_size], ecx
    mov [mmap_last_size + 4], eax
    jmp .__mmap_srch_lp
.__mmap_srch_done:
    mov ecx, esi
%endmacro


    section .data

struc MemDesc
.base resq 1
.size resq 1
.type resd 1
endstruc

mmap_last_size equ 0x7C00
mmap_buff      equ 0x7C08
