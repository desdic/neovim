local ok, nightfox = pcall(require, "nightfox")
if not ok then
    vim.notify("Unable to require nightfox", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

nightfox.load("nightfox")
