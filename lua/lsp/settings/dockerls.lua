return {
    cmd = {
        DATA_PATH ..
            "/mason/bin/docker-langserver",
        "--stdio"
    },
    root_dir = vim.loop.cwd
}
