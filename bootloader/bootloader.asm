org 0x7c00                   
      

mov [BOOT_DISK], dl                 



CODE_SEG equ GDT_code - GDT_start
DATA_SEG equ GDT_data - GDT_start

cli
        mov ax, 0x50
        mov es, ax
        xor bx, bx

        mov al, 5
        mov ch, 0
        mov cl, 2
        mov dh, 0
        mov dl, 0

        mov ah, 0x02
        int 0x13

; clear the screen

mov ah, 0x0
mov al, 0x03
int 0x10

lgdt [GDT_descriptor]
mov eax, cr0
or eax, 1
mov cr0, eax
jmp CODE_SEG:start_protected_mode

jmp $
                                    
                                     
GDT_start:                          ; must be at the end of real mode code
    GDT_null:
        dd 0x0
        dd 0x0

    GDT_code:
        dw 0xffff
        dw 0x0
        db 0x0
        db 0b10011010
        db 0b11001111
        db 0x0

    GDT_data:
        dw 0xffff
        dw 0x0
        db 0x0
        db 0b10010010
        db 0b11001111
        db 0x0

GDT_end:

GDT_descriptor:
    dw GDT_end - GDT_start - 1
    dd GDT_start


[bits 32]
start_protected_mode:
    mov al, 'A'
    mov ah, 0x0f
    mov [0xb8000], ax
	jmp [500h + 18h]
    jmp $

BOOT_DISK: db 0                                     
 
times 510-($-$$) db 0              
dw 0xaa55
