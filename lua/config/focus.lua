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

local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

keymap("n", "<Leader>h", ":FocusSplitLeft<CR>", opts)
keymap("n", "<Leader>j", ":FocusSplitDown<CR>", opts)
keymap("n", "<Leader>k", ":FocusSplitUp<CR>", opts)
keymap("n", "<Leader>l", ":FocusSplitRight<CR>", opts)
