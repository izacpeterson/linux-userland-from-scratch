# linux-userland-from-scratch

Building a tiny Linux userland from scratch in Rust because apparently I hate myself (affectionately). No glibc, no busybox, no pre-made anything. Just raw Rust binaries, a kernel, and vibes. The shell runs as PID 1 and `init` just keeps restarting it if it dies, which is honestly a valid life philosophy.

## How it works

1. Rust tools compile to static musl binaries — no libc, no dependencies, no excuses
2. They get installed into a `rootfs/` directory
3. `init` runs as PID 1, immediately spawns a shell, and loops forever if it crashes
4. The rootfs gets packed into an initramfs
5. QEMU boots a custom Linux kernel with it — or it can be turned into a bootable ISO

## Userland so far

| Binary  | What it does                              |
| ------- | ----------------------------------------- |
| `init`  | PID 1, babysits the shell                 |
| `sh`    | a shell, the one thing you actually need  |
| `ls`    | look at your files                        |
| `cat`   | print a file into the void               |
| `echo`  | yell things at stdout                     |

## Running it

You'll need:
- The `x86_64-unknown-linux-musl` Rust target
- A built Linux kernel
- QEMU

```sh
make          # build everything and pack the initramfs
make boot     # boot in QEMU with a serial console

make iso      # wrap it in a GRUB bootable ISO
make boot-iso # boot the ISO in QEMU (with a display this time)

make clean    # burn it all down and start over
```

Want to boot it on real hardware? Flash the ISO to a USB drive:

```sh
dd if=boot.iso of=/dev/sdX bs=4M status=progress
```

(double-check your `/dev/sdX` before running that, you know the drill)
