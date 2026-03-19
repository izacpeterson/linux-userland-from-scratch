use std::{
    io::{Write, stdin, stdout},
    process::Command,
};

pub fn run() {
    loop {
        let currentDir = std::env::current_dir().unwrap();
        print!("{} > ", currentDir.display());

        stdout().flush();

        let mut input = String::new();
        stdin().read_line(&mut input).unwrap();

        if input.is_empty() {
            continue;
        }

        let mut parts = input.trim().split_whitespace();
        let command = parts.next().unwrap();
        let args: Vec<&str> = parts.collect();

        match command {
            "cd" => {
                let dir = args.get(0).unwrap_or(&"/");
                std::env::set_current_dir(dir);
                continue;
            }

            "echo" => crate::tools::echo::run(&args),
            "ls" => crate::tools::ls::run(),
            "cat" => crate::tools::cat::run(args.get(0).unwrap()),

            _ => match Command::new(command).args(args).spawn() {
                Ok(mut child) => {
                    child.wait().unwrap();
                }
                Err(_) => eprintln!("Command not found"),
            },
        }
    }
}
