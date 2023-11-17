
bits 16

_start:
	jmp boot

msg db "Welcome to Tristan's operating system",0x0a,0x0d,0x00

boot:
	mov si,msg
print_welcome:
	mov ah,0x0E
	mov bh,0
	lodsb
	CMP al,0x00
	JE halt_kernel
	int 0x10
	JMP print_welcome

halt_kernel:
	cli
	cld

	mov ax, 0x50
	mov es, ax
	xor bx, bx

	mov al, 2
	mov ch, 0
	mov cl, 2
	mov dh, 0
	mov dl, 0

	mov ah, 0x02
	int 0x13
	;jmp [500h + 18h]

	lgdt [gdt_descriptor]
	mov eax, cr0
	or eax, 1
	mov cr0, eax
	
	CODE_SEG equ code_descriptor - gdt_start
	DATA_SEG equ data_descriptor - gdt_start
	
	jmp CODE_SEG:start_protected_mode
	hlt

gdt_start:
	null_descriptor:
		dd 0 ; 0x00 0x00 0x00 0x00
		dd 0 ; 0x00 0x00 0x00 0x00

	code_descriptor:
		dw 0xffff ; first 16 bits of the limit
		dw 0 ; 0x00 0x00
		db 0 ; 0x00 First 24 bits of the base
		db 10011010 ;present, privelege, type proerties
		db 11001111
		db 0
	
	data_descriptor:
		dw 0xffff
		dw 0
		dw 0
		db 10010010
		db 11001111
		db 0
	
gdt_end:
	
gdt_descriptor:
	dw gdt_end - gdt_start - 1
	dd gdt_start

[bits 32]
start_protected_mode:
	mov al, "A"
	mov ah, 0x0f
	mov [0xb8000], ax
	mov eax, 0
	inc eax
	hlt

times 510 - ($-$$) db 0
dw 0xAA55
