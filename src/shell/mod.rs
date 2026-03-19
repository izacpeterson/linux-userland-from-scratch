use std::{
    io::{Write, stdin, stdout},
    path::Path,
    process::Command,
};

pub fn run() {
    println!("Welcome to izacos");
    loop {
        let current_dir = std::env::current_dir().unwrap();
        print!("{} > ", current_dir.display());

        let _ = stdout().flush();

        let mut input = String::new();
        stdin().read_line(&mut input).unwrap();

        if input.is_empty() {
            continue;
        }

        let mut parts = input.trim().split_whitespace();
        let command = parts.next().unwrap();
        let args: Vec<&str> = parts.collect();
        match command {
            "cd" => crate::builtins::cd::run(&args),
            "exit" => break,
            _ => run_external(command, &args),
        }
    }
}

fn run_external(command: &str, args: &[&str]) {
    let full_path = format!("/bin/{}", command);

    if !Path::new(&full_path).exists() {
        eprintln!("Command not found: {}", command);
        return;
    }

    match Command::new(full_path).args(args).spawn() {
        Ok(mut child) => {
            if let Err(err) = child.wait() {
                eprintln!("Failed waiting on child: {}", err);
            }
        }
        Err(err) => eprintln!("Failed to run {}: {}", command, err),
    }
}
