OUTPUT(bootloader)

PHDRS
{
	headers PT_NULL;
	code PT_LOAD FILEHDR PHDRS FLAGS(0x1 | 0x2 | 0x4);
	data PT_LOAD;
}

SECTIONS
{
	. = SIZEOF_HEADERS;

	.text 0x7c00 : { *(.text) } : code

	.data : { *(.data) }: data
}
