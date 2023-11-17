#include <stdint.h>
#include "stdio.h"
#include "interrupts.h"

void main() {
	printf("Hello world\n");
	int a = 5;
	printint(12345);
	printptr(&a);
	init_interrupts();
	asm volatile("int $0x7b");
	for (;;) {}
}
