KERNEL := $(HOME)/Dev/linux-6.12/arch/x86/boot/bzImage
INITRD := initramfs.cpio.gz
TARGET := target/x86_64-unknown-linux-musl/release

SH := $(TARGET)/sh
LS := $(TARGET)/ls
CAT := $(TARGET)/cat
ECHO := $(TARGET)/echo

.PHONY: all build install pack boot clean

all: build install pack

build:
	RUSTFLAGS="-C relocation-model=static" cargo build --target x86_64-unknown-linux-musl --release --bins

install:
	mkdir -p rootfs/bin rootfs/sbin
	cp $(SH) rootfs/sbin/init
	cp $(SH) rootfs/bin/sh
	cp $(LS) rootfs/bin/ls
	cp $(CAT) rootfs/bin/cat
	cp $(ECHO) rootfs/bin/echo
	chmod +x rootfs/sbin/init rootfs/bin/sh rootfs/bin/ls rootfs/bin/cat rootfs/bin/echo

pack:
	cd rootfs && find . | cpio -o -H newc | gzip > ../$(INITRD)

boot: all
	qemu-system-x86_64 \
		-kernel $(KERNEL) \
		-initrd $(INITRD) \
		-append "console=ttyS0 rdinit=/sbin/init quiet" \
		-nographic

clean:
	cargo clean
	rm -f $(INITRD)
	rm -f rootfs/sbin/init rootfs/bin/sh rootfs/bin/ls rootfs/bin/cat rootfs/bin/echo