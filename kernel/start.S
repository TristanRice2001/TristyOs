.extern main

.section .data
	

.section .bss
	.align 16
	stack_top:
		 .skip 0x16384
	stack_bottom:

.section .text

.global _start


_start:
	inc %esp
	mov $0x5000, %esp
	call main
	inc %eax
	cli
	hlt

.size _start, . - _start
