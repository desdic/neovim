
local status_ok, lspcfg = pcall(require, "lspconfig")
if not status_ok then
    vim.notify("Unable to requre lspconfig", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

return {
    cmd = {DATA_PATH .. "/lsp_servers/gopls/gopls", "serve"},
    settings = {
        gopls = {
            analyses = {unusedparams = true},
            staticcheck = true,
            gofumpt = true
        }
    },
    root_dir = lspcfg.util.root_pattern(".git", "go.mod", "."),
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        gofumpt = true
    }
}
