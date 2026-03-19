KERNEL := $(HOME)/Dev/linux-6.12/arch/x86/boot/bzImage
INITRD := initramfs.cpio.gz
BINARY := target/x86_64-unknown-linux-musl/release/MyLinuxTools

.PHONY: all build pack boot clean

all: build pack

build:
	RUSTFLAGS="-C relocation-model=static" cargo build --target x86_64-unknown-linux-musl --release
	cp $(BINARY) rootfs/sbin/init

pack:
	cd rootfs && find . | cpio -oH newc | gzip > ../$(INITRD)

boot: all
	qemu-system-x86_64 \
		-kernel $(KERNEL) \
		-initrd $(INITRD) \
		-append "console=ttyS0 rdinit=/sbin/init quiet" \
		-nographic

clean:
	cargo clean
	rm -f $(INITRD)