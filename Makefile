KERNEL := $(HOME)/Dev/linux-6.12/arch/x86/boot/bzImage
INITRD := initramfs.cpio.gz
ISO := boot.iso
ISO_ROOT := iso_root
TARGET := target/x86_64-unknown-linux-musl/release

SH := $(TARGET)/sh
LS := $(TARGET)/ls
CAT := $(TARGET)/cat
ECHO := $(TARGET)/echo
INIT := ${TARGET}/init

.PHONY: all build install pack boot iso boot-iso clean

all: build install pack

build:
	RUSTFLAGS="-C relocation-model=static" cargo build --target x86_64-unknown-linux-musl --release --bins

install:
	mkdir -p rootfs/bin rootfs/sbin
	cp $(INIT) rootfs/sbin/init
	cp $(SH) rootfs/bin/sh
	cp $(LS) rootfs/bin/ls
	cp $(CAT) rootfs/bin/cat
	cp $(ECHO) rootfs/bin/echo
	chmod +x rootfs/sbin/*

pack:
	cd rootfs && find . | cpio -o -H newc | gzip > ../$(INITRD)

boot: all
	qemu-system-x86_64 \
		-kernel $(KERNEL) \
		-initrd $(INITRD) \
		-append "console=ttyS0 rdinit=/sbin/init quiet" \
		-nographic

iso: all
	mkdir -p $(ISO_ROOT)/boot/grub
	cp $(KERNEL) $(ISO_ROOT)/boot/
	cp $(INITRD) $(ISO_ROOT)/boot/
	printf 'set timeout=3\nset default=0\n\nmenuentry "mylinux" {\n\tlinux /boot/bzImage console=tty0 rdinit=/sbin/init nomodeset\n\tinitrd /boot/initramfs.cpio.gz\n}\n' > $(ISO_ROOT)/boot/grub/grub.cfg
	grub2-mkrescue -o $(ISO) $(ISO_ROOT)

boot-iso: iso
	qemu-system-x86_64 -cdrom $(ISO) -m 512M

clean:
	cargo clean
	rm -f $(INITRD)
	rm -f $(ISO)
	rm -rf $(ISO_ROOT)
	rm -f rootfs/sbin/init rootfs/bin/sh rootfs/bin/ls rootfs/bin/cat rootfs/bin/echo