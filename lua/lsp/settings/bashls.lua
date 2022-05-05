return {
    cmd = {
        "node",
        DATA_PATH ..
            "/lsp_servers/bashls/node_modules/bash-language-server/bin/main.js",
        "start"
    },
    filetypes = {"sh", "zsh"}
}
