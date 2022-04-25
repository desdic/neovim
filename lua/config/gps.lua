local ok, gps = pcall(require, "nvim-gps")
if not ok then
    vim.notify("Unable to require nvim-gps", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

gps.setup()
