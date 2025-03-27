return {
    cmd = { "pylsp" },
    filetypes = { "python" },
    root_markers = { "setup.py", "pyproject.toml", "requirements.txt", ".git" },
    single_file_support = true,
    plugins = {
        rope_import = {
            enabled = true,
        },
    },
}
