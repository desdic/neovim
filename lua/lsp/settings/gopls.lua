return {
    cmd = {DATA_PATH .. "/lsp_servers/go/gopls", "serve"},
    settings = {
        gopls = {
            analyses = {unusedparams = true},
            staticcheck = true,
            gofumpt = true
        }
    },
    root_dir = require("lspconfig").util.root_pattern(".git", "go.mod", "."),
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        gofumpt = true
    }
}
