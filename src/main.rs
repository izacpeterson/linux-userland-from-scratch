pub mod shell;
pub mod tools;

use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    let tool = args.get(1).map(|s| s.as_str()).unwrap_or("");

    match tool {
        "cat" => tools::cat::run(),
        "echo" => tools::echo::run(),
        "init" | "sh" => shell::run(),
        _ => eprintln!("pulsar: unknown command: {}", tool),
    }
}
