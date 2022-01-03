local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    vim.notify("Unable to requre lspconfig")
    return
end

require("config.lsp-installer")
require("lsp.handlers").setup()
require("config.null-ls").config()
