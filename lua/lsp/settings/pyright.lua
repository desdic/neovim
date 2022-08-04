return {
    cmd = {
        DATA_PATH ..
            "/mason/bin/pyright-langserver",
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
