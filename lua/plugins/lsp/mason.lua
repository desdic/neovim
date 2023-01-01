local ok, mason = pcall(require, "mason")
if not ok then
    vim.notify("Unable to require mason", vim.lsp.log_levels.ERROR, {title = "Plugin error"})
    return
end

mason.setup()
