use std::fs;

pub fn run(file: &str) {
    match fs::read_to_string(file) {
        Ok(contents) => println!("{}", contents),
        Err(err) => eprintln!("Error reading file: {}", err),
    }
}
