# linux-userland-from-scratch

Building a mini Linux userland from scratch in Rust — not just a few tools, but an actual bootable system. There's no glibc, no busybox, no existing userland. Just Rust binaries, a kernel, and whatever I've written so far. The shell runs as PID 1.

## How it works

1. Rust tools compile to static musl binaries (no libc, no dependencies)
2. They get installed into a `rootfs/` directory
3. `sh` gets copied to `/sbin/init` — the first thing the kernel runs
4. The rootfs is packed into an initramfs
5. QEMU boots a custom Linux kernel with it

## Userland so far

| Binary | What it does        |
| ------ | ------------------- |
| `sh`   | shell / PID 1       |
| `ls`   | list files          |
| `cat`  | print file contents |
| `echo` | print stuff         |

## Running it

You'll need the `x86_64-unknown-linux-musl` Rust target, a built Linux kernel, and QEMU.

```sh
make        # build + pack initramfs
make boot   # boot in QEMU
make clean  # clean up
```
