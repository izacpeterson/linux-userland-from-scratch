use std::fs;

fn main() {
    let path = ".";

    let entries = fs::read_dir(path).unwrap();

    for entry in entries {
        let entry = entry.unwrap();
        println!("{}", entry.path().display());
    }
}
