
bits 16

_start:
	jmp boot

msg db "Welcome to Tristan's operating system",0x0a,0x0d,0x00

global_descriptor_table:
	

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
	jmp [500h + 18h]

	hlt

times 510 - ($-$$) db 0
dw 0xAA55
