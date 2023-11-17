ENTRY(_start);

PHDRS
{
	headers PT_NULL FILEHDR;
	code PT_LOAD;
	data PT_LOAD;
}

SECTIONS
{
	.text 0x600: ALIGN(0x100) { *(.text) }: code
	.data : { *(.data) }
	.bss : { *(.bss) }
	/DISCARD/ : { *(.eh_frame) }
}
