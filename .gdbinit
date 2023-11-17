define hook-stop
	printf "[%4x:%4x] ", $cs, $eip
	x/i $cs*16+$eip
end

symbol-file ./build/kernel/kernel

set disassembly-flavor intel

layout asm
layout reg

set architecture i8086

target remote localhost:26000

b *0x600
