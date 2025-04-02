return {
    cmd = { "pylsp" },
    filetypes = { "python" },
    root_markers = { "setup.py", "pyproject.toml", "requirements.txt", ".git" },
    plugins = {
        rope_import = {
            enabled = true,
        },
    },
}
