local lsok, ib = pcall(require, "indent_blankline")
if not lsok then
    vim.notify("Unable to require indent_blankline", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

ib.setup()
