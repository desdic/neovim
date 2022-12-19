local ok, stabilize = pcall(require, "stabilize")
if not ok then
    vim.notify("Unable to require stabilize", vim.lsp.log_levels.ERROR, {title = "Plugin error"})
    return
end

stabilize.setup()
