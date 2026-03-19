pub mod shell;
pub mod tools;

use std::env;

fn main() {
    println!("Welcome to IzacOS");
    shell::run();
}
