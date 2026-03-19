pub fn run(args: &[&str]) {
    let dir = args.get(0).copied().unwrap_or("/");

    if let Err(err) = std::env::set_current_dir(dir) {
        eprintln!("cd: {}", err);
    }
}
