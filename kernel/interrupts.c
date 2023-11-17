#include <stdint.h>
#include "stdio.h"

const int MAX_IDT_ENTRIES = 256;

struct IDT_Entry {
	uint16_t func_addr_lower; // bits 0 to 16 of 32 bit function address 0x_0123_ 4567
	uint8_t type_attributes;
	uint8_t zero;
	uint16_t segment_selector;
	uint16_t func_addr_upper; // bits 17 to 32 of 32 bit function address 0x0123 _4567_
};

struct idt_record {
	uint16_t limit;
	uintptr_t *base;
};


struct IDT_Entry register_idt_entry(void (*interrupt_handler)(char *)) {
	/*
		0x01234567
	*/

	uint16_t func_addr_lower = (uint16_t) (((uint32_t) interrupt_handler) >> 16);
	printint((int) func_addr_lower);
	uint16_t func_addr_upper = (uint16_t) (((uint32_t) interrupt_handler) & 0x0000FFFF);

	uint8_t zero = 0x0;
	/*
		P    -  present bit. This must be 1 for descriptor to be valid

		PL   -  Privelege level. This defines the privelege level to access 
			    this interrupt. (00 for ring zero privelege level)

		0    -  This bit should just be 0 ??
		
		GATE -  Gate type. Just setting this to 32 bit interrupt gate for now
	*/
	//                          PPL0GATE
	uint8_t type_attributes = 0b10001110;

	uint16_t segment_selector = 0x0;

	struct IDT_Entry entry;

	entry.func_addr_lower = func_addr_lower;
	entry.func_addr_upper = func_addr_upper;
	entry.zero = zero;
	entry.type_attributes = type_attributes;
	entry.segment_selector = segment_selector;

	return entry;
}

void test(char * a) {
	int b = 0;
}

void init_interrupts() {
	struct IDT_Entry idt_entries[MAX_IDT_ENTRIES];
	struct IDT_Entry entry = register_idt_entry(&test);
	printptr(&test);
	idt_entries[123] = entry;

	struct {
		uint16_t base;
		uint32_t limit;
	} idt_descriptor;

	idt_descriptor.limit = sizeof(idt_entries) - 1;
	idt_descriptor.base = (uint32_t) &idt_entries;

	asm volatile("lidt %0" : : "m"(idt_descriptor));
	
	asm volatile("sti");
}