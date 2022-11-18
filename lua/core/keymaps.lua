vim.keymap.set("n", "<C-h>", "<C-W>h",
               {silent = true, noremap = true, desc = "Move to window on left"})
vim.keymap.set("n", "<C-j>", "<C-W>j",
               {silent = true, noremap = true, desc = "Move to window below"})
vim.keymap.set("n", "<C-k>", "<C-W>k",
               {silent = true, noremap = true, desc = "Move to window above"})
vim.keymap.set("n", "<C-l>", "<C-W>l", {
    silent = true,
    noremap = true,
    desc = "Move to window on right"
})

-- vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {silent = true, noremap = true, desc = "Easy escape in terminal mode"})

vim.keymap.set("", "<Leader>c", ":close<CR>",
               {silent = true, noremap = true, desc = "Close window"})
vim.keymap.set("", "<Leader>w", ":w!<CR>",
               {silent = true, noremap = true, desc = "Write buffer"})
-- vim.keymap.set("", "<Leader>q", ":br <BAR> bd #<CR>", {silent = true, noremap = true})
vim.keymap.set("", "<Leader>q", ":bdelete!<CR>",
               {silent = true, noremap = true, desc = "Close buffer"})

vim.keymap.set("v", "<", "<gv",
               {silent = true, noremap = true, desc = "Align to left"})
vim.keymap.set("v", ">", ">gv",
               {silent = true, noremap = true, desc = "Align to right"})

vim.keymap.set("n", "<Leader>qa", ":qa!<CR>",
               {silent = true, noremap = true, desc = "Quit"})

vim.keymap.set("i", "<C-H>", "<C-W>",
               {silent = true, noremap = true, desc = "Delete word backwards"})

-- jk as escape
vim.keymap.set("i", "jk", "<ESC>",
               {silent = true, noremap = true, desc = "Escape in insert mode"})

vim.keymap.set("n", "<Leader><space>", ":nohlsearch<CR>", {
    noremap = true,
    silent = false,
    expr = false,
    desc = "Remove search"
})

vim.keymap.set("n", "<Leader>pack", ":PackerSync<CR>",
               {silent = true, noremap = true, desc = "Run PackerSync"})

vim.cmd(
    'command! -nargs=0 LspVirtualTextToggle lua require("lsp/virtual_text").toggle()')

-- vim.keymap.set("n", "<Leader>r", ":e!<CR>", { silent = true, noremap = true, desc = "Reload file" })

vim.keymap.set("n", "<Leader>cm", ":delmarks a-zA-Z0-9<CR>",
               {silent = true, noremap = true, desc = "Clear all marks"})

-- Keymaps for plugins is located with plugin setup

vim.keymap.set("n", "Y", "yg$",
               {silent = true, noremap = true, desc = "yank line"})
vim.keymap.set("x", "<Leader>p", '"_dP',
               {silent = true, noremap = true, desc = "paste?"})
vim.keymap.set({"n", "v"}, "<Leader>y", '"+y',
               {silent = true, noremap = true, desc = "yank to clipboard"})
vim.keymap.set("n", "<Leader>Y", '"+Y',
               {silent = true, noremap = true, desc = "yank line to clipboard"})

-- The mapping xnoremap p "_dP changes the behavior of p when pasting over selected text which is at the end of a line. That occurs because when text at the end of a line is deleted, the cursor moves back to the last character on the line, and P then pastes before that last character.
vim.keymap.set({"n", "v"}, "<Leader>d", '"_d',
               {silent = true, noremap = true, desc = "delete?"})

vim.keymap.set("n", "n", "nzzzv",
               {silent = true, noremap = true, desc = "search next and center"})
vim.keymap.set("n", "N", "Nzzzv",
               {silent = true, noremap = true, desc = "search next and center"})
vim.keymap.set("n", "J", "mzJ`z", {
    silent = true,
    noremap = true,
    desc = "join next line and center"
})
vim.keymap.set("n", "<C-d>", "<C-d>zz",
               {silent = true, noremap = true, desc = "jump center"})
vim.keymap.set("n", "<C-u>", "<C-u>zz",
               {silent = true, noremap = true, desc = "jump center"})
