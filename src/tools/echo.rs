use std::env;

pub fn run() {
    let args: Vec<String> = env::args().skip(2).collect();
    println!("{}", args.join(" "));
}
