BUILD_DIR= ../build/kernel
OS=$(BUILD_DIR)/kernel

CFLAGS += -ffreestanding -nostdlib -gdwarf-4 -m32 -ggdb3

KERNEL_SRCS := $(wildcard *.S)
KERNEL_OBJS := $(patsubst %.S, $(BUILD_DIR)/%.o, $(KERNEL_SRCS))

all: $(OS)

$(BUILD_DIR)/%.o: %.c
	gcc $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: %.S
	gcc $(CFLAGS) -c $< -o $@

$(OS): $(KERNEL_OBJS)
	i386-elf-gcc $(CFLAGS) -c kernel.c -o $(BUILD_DIR)/kernel.o
	i386-elf-gcc $(CFLAGS) -c stdio.c -o $(BUILD_DIR)/stdio.o
	i386-elf-gcc $(CFLAGS) -c interrupts.c -o $(BUILD_DIR)/interrupts.o
	ld -m elf_i386 --nmagic -T kernel.lds $(BUILD_DIR)/start.o $(BUILD_DIR)/interrupts.o $(BUILD_DIR)/stdio.o $(BUILD_DIR)/kernel.o -o $@

clean:
	rm $(BUILD_DIR)/*

