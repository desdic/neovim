local lsok, ib = pcall(require, "indent_blankline")
if not lsok then
    vim.notify("Unable to require indent_blankline")
    return
end

ib.setup()
