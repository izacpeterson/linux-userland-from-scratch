use std::fs;

fn main() {
    let mut args = std::env::args().skip(1);

    let path = match args.next() {
        Some(p) => p,
        None => {
            println!("No file specified");
            return;
        }
    };

    let content = args.collect::<Vec<String>>().join(" ");

    if let Err(e) = fs::write(&path, content + "\n") {
        eprintln!("write: {}: {}", path, e);
    }
}
