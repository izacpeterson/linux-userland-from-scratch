use std::fs;

fn main() {
    // let path = ".";
    let path = std::env::args().nth(1).unwrap_or_else(|| ".".to_string());

    let entries = fs::read_dir(path).unwrap();

    for entry in entries {
        let entry = entry.unwrap();
        println!("{}", entry.path().display());
    }
}
