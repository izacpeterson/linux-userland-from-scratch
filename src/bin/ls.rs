use std::fs;

fn main() {
    // let path = ".";
    let path = std::env::args().nth(1).unwrap_or_else(|| ".".to_string());

    let entries = fs::read_dir(path).unwrap();

    for entry in entries {
        let entry = entry.unwrap();

        let is_dir = entry.file_type().unwrap().is_dir();

        let name = entry.file_name();
        let name = name.to_string_lossy();

        if is_dir {
            println!("/{}", name);
        } else {
            println!("{}", name);
        }
    }
}
