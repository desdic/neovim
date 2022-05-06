return {
    cmd = {
        DATA_PATH ..
            "/lsp_servers/dockerls/node_modules/dockerfile-language-server-nodejs/bin/docker-langserver",
        "--stdio"
    },
    root_dir = vim.loop.cwd
}
