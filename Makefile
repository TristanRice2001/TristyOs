BUILD_DIR=build
BOOTLOADER=$(BUILD_DIR)/bootloader/bootloader
KERNEL=$(BUILD_DIR)/kernel/kernel
DISK_IMG_NAME=$(BUILD_DIR)/disk.img

all: bootdisk

.PHONY: bootdisk bootloader kernel

bootloader:
	make -C bootloader


kernel:
	make -C kernel


bootdisk: kernel bootloader
	dd if=/dev/zero of=$(DISK_IMG_NAME) bs=512 count=2880
	dd conv=notrunc if=$(BOOTLOADER) of=$(DISK_IMG_NAME) bs=512 count=1 seek=0
	dd conv=notrunc if=$(KERNEL) of=$(DISK_IMG_NAME) bs=512 count=3 seek=1

clean:
	make -C bootloader clean
	make -C kernel clean
	rm $(BUILD_DIR)/disk.img

qemu:
	qemu-system-i386 -machine q35 -fda $(DISK_IMG_NAME) -gdb tcp::26000 -S

qemuFree:
	qemu-system-i386 -machine q35 -fda $(DISK_IMG_NAME)

