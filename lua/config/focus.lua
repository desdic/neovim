local ok, focus = pcall(require, "focus")
if not ok then
    vim.notify("Unable to require focus", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

focus.setup({
    enable = true,
    cursorline = false,
    signcolumn = true,
    number = false,
    excluded_filetypes = {"toggleterm"}
})

local opts = {noremap = true, silent = true}

vim.keymap.set("n", "<Leader>h", ":FocusSplitLeft<CR>", opts)
vim.keymap.set("n", "<Leader>j", ":FocusSplitDown<CR>", opts)
vim.keymap.set("n", "<Leader>k", ":FocusSplitUp<CR>", opts)
vim.keymap.set("n", "<Leader>l", ":FocusSplitRight<CR>", opts)
