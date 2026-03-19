use std::fs;

fn main() {
    let file = std::env::args().nth(1);

    match file {
        Some(path) => match fs::read_to_string(&path) {
            Ok(contents) => println!("{}", contents),
            Err(err) => eprintln!("Error reading file: {}", err),
        },
        None => eprintln!("Please provide a file path"),
    }
}
