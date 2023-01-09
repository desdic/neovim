return {
    -- Mason
    {"williamboman/mason.nvim", cmd = "Mason", opts = {}}, -- Mason LSP
    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                "gopls", "sumneko_lua", "bashls", "yamlls", "pyright", "pylsp", "efm", "solargraph", "dockerls",
                "clangd", "jsonls", "perlnavigator", "rust_analyzer"
            },
            automatic_installation = true
        }
    }
}
