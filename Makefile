KERNEL := $(HOME)/Dev/linux-6.12/arch/x86/boot/bzImage
INITRD := initramfs.cpio.gz
ISO := boot.iso
ISO_ROOT := iso_root
TARGET := target/x86_64-unknown-linux-musl/release

INIT := $(TARGET)/init
SH := $(TARGET)/sh
LS := $(TARGET)/ls
CAT := $(TARGET)/cat
ECHO := $(TARGET)/echo
PWD := $(TARGET)/pwd
WRITE := $(TARGET)/write
CLEAR := $(TARGET)/clear


.PHONY: all build install pack boot iso boot-iso clean


all: build install pack


build:
	RUSTFLAGS="-C relocation-model=static" \
	cargo build --target x86_64-unknown-linux-musl --release --bins


install:
	mkdir -p rootfs/bin rootfs/sbin
	cp $(INIT) rootfs/sbin/init
	cp $(SH) rootfs/bin/sh
	cp $(LS) rootfs/bin/ls
	cp $(CAT) rootfs/bin/cat
	cp $(CAT) rootfs/bin/read
	cp $(ECHO) rootfs/bin/echo
	cp $(PWD) rootfs/bin/pwd
	cp $(WRITE) rootfs/bin/write
	cp $(CLEAR) rootfs/bin/clear


	chmod +x rootfs/sbin/* rootfs/bin/*


pack:
	cd rootfs && find . | cpio -o -H newc | gzip > ../$(INITRD)


boot: all
	qemu-system-x86_64 \
		-kernel $(KERNEL) \
		-initrd $(INITRD) \
		-append "console=tty0 console=ttyS0 rdinit=/sbin/init nomodeset loglevel=7 quiet" \
		-nographic


iso: all
	mkdir -p $(ISO_ROOT)/boot
	cp $(KERNEL) $(ISO_ROOT)/boot/bzImage
	cp $(INITRD) $(ISO_ROOT)/boot/initramfs.cpio.gz
	grub2-mkrescue -o $(ISO) $(ISO_ROOT)


boot-iso: iso
	qemu-system-x86_64 \
		-cdrom $(ISO) \
		-m 512M


clean:
	cargo clean
	rm -f $(INITRD)
	rm -f $(ISO)
	rm -f $(ISO_ROOT)/boot/bzImage
	rm -f $(ISO_ROOT)/boot/initramfs.cpio.gz
	rm -f rootfs/sbin/init rootfs/bin/sh rootfs/bin/ls rootfs/bin/cat rootfs/bin/echo