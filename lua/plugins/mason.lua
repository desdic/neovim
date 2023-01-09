local M = {"williamboman/mason.nvim", cmd = "Mason", dependencies = {"williamboman/mason-lspconfig.nvim"}}

function M.config()
    require("mason").setup()

    require("mason-lspconfig").setup({
        ensure_installed = {
            "gopls", "sumneko_lua", "bashls", "yamlls", "pyright", "pylsp", "efm", "solargraph", "dockerls", "clangd",
            "jsonls", "perlnavigator", "rust_analyzer"
        },
        automatic_installation = true
    })
end

return M
