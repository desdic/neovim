vim.keymap.set("n", "<C-h>", "<C-W>h", {silent = true})
vim.keymap.set("n", "<C-j>", "<C-W>j", {silent = true})
vim.keymap.set("n", "<C-k>", "<C-W>k", {silent = true})
vim.keymap.set("n", "<C-l>", "<C-W>l", {silent = true})

vim.keymap.set("n", "<S-l>", ":bnext<CR>", {silent = true})
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", {silent = true})

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {silent = true})

vim.keymap.set("", "<Leader>c", ":close<CR>", {silent = true})
vim.keymap.set("", "<Leader>w", ":w!<CR>", {silent = true})
vim.keymap.set("", "<Leader>q", ":br <BAR> bd #<CR>", {silent = true})

vim.keymap.set("v", "<", "<gv", {silent = true})
vim.keymap.set("v", ">", ">gv", {silent = true})

vim.keymap.set("n", "<C-m-j>", ":m .+1<CR>==", {silent = true})
vim.keymap.set("n", "<C-m-k>", ":m .-2<CR>==", {silent = true})
vim.keymap.set("i", "<C-m-j>", "<Esc>:m .+1<CR>==gi", {silent = true})
vim.keymap.set("i", "<C-m-k>", "<Esc>:m .-2<CR>==gi", {silent = true})
vim.keymap.set("v", "<C-m-j>", ":m '>+1<CR>gv=gv", {silent = true})
vim.keymap.set("v", "<C-m-k>", ":m '<-2<CR>gv=gv", {silent = true})

vim.keymap.set("n", "<Leader>qa", ":qa!<CR>", {silent = true})

vim.keymap.set("i", "<C-H>", "<C-W>", {silent = true})

-- jk as escape
vim.keymap.set("i", "jk", "<ESC>", {silent = true})

vim.keymap.set("n", "<Leader><space>", ":nohlsearch<CR>",
               {noremap = true, silent = false, expr = false})

vim.keymap.set("n", "<Leader>pack", ":PackerSync<CR>", {silent = true})

vim.cmd(
    'command! -nargs=0 LspVirtualTextToggle lua require("lsp/virtual_text").toggle()')

vim.keymap.set("n", "<Leader>r", ":e!<CR>", {silent = true})
