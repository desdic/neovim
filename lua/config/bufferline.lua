local ok, bufferline = pcall(require, "bufferline")
if not ok then
    vim.notify("Unable to require bufferline", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

bufferline.setup({})
