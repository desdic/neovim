return {
    cmd = {
        "node",
        DATA_PATH ..
            "/lsp_servers/pyright/node_modules/pyright/dist/pyright-langserver.js",
        "--stdio"
    },
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true
            }
        }
    }
}
