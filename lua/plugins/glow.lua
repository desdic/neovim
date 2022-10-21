local status_ok, _ = pcall(require, "glow")
if not status_ok then
    vim.notify("Unable to require glow", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

vim.g.glow_border = "rounded"
