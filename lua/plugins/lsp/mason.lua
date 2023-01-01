local ok, mason = pcall(require, "mason")
if not ok then
    vim.notify("Unable to require mason", vim.lsp.log_levels.ERROR, {title = "Plugin error"})
    return
end

local oklsp, masonlsp = pcall(require, "mason-lspconfig")
if not oklsp then
    vim.notify("Unable to require mason-lspconfig", vim.lsp.log_levels.ERROR, {title = "Plugin error"})
    return
end

mason.setup()

masonlsp.setup({
    ensure_installed = {
        "gopls", "sumneko_lua", "bashls", "yamlls", "pyright", "pylsp", "efm", "solargraph", "dockerls", "clangd",
        "jsonls", "perlnavigator", "rust_analyzer"
    },
    automatic_installation = true
})
