return {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = { "setup.py", "ruff.toml", ".ruff.toml" },
    single_file_support = true,
    settings = {},
}
