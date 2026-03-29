# linux-userland-from-scratch

Building a tiny Linux userland from scratch in Rust because apparently I hate myself (affectionately). Just raw Rust binaries, a kernel, and vibes. I wrote my own init and shell — they worked, mostly, until they didn't. Busybox handles those now. No shame. I also picked up micro for editing files like a civilized person, and QuickJS because JavaScript deserves to run on a 3MB system too.

I really just wanted to learn a bit more about Linux, and improve my rust skills. This seemed like a good way to do both.

## How it works

1. Rust tools compile to static musl binaries — no libc, no dependencies, no excuses
2. Busybox handles init and the shell (my versions were mid, it happens)
3. Everything gets installed into a `rootfs/` directory
4. The rootfs gets packed into an initramfs
5. QEMU boots a custom Linux kernel with it — or it can be turned into a bootable ISO

## Userland so far

| Binary  | What it does                              |
| ------- | ----------------------------------------- |
| `init`  | PID 1, courtesy of busybox                |
| `sh`    | busybox shell, the one thing you need     |
| `micro` | a real text editor, for real people       |
| `qjs`   | QuickJS — JavaScript on a tiny Linux box  |
| `ls`    | look at your files                        |
| `cat`   | print a file into the void                |
| `echo`  | yell things at stdout                     |
| `pwd`   | where even am I                           |
| `write` | write text to a file like a normal person |
| `clear` | out with the old                          |

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
