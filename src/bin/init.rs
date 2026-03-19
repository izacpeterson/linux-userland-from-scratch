use std::process::Command;

fn main() {
    println!("Welcome to izacos");

    loop {
        match Command::new("/bin/sh").spawn() {
            Ok(mut child) => match child.wait() {
                Ok(status) => {
                    println!("shell exited with status: {}", status);
                }
                Err(err) => {
                    eprintln!("init: failed waiting on shell: {}", err);
                }
            },
            Err(err) => {
                eprintln!("init: failed to start shell: {}", err);
            }
        }
    }
}
