local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

-- Easy navigation
keymap("n", "<C-h>", " <C-W>h", opts)
keymap("n", "<C-j>", " <C-W>j", opts)
keymap("n", "<C-k>", " <C-W>k", opts)
keymap("n", "<C-l>", " <C-W>l", opts)

keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

keymap("t", "<Esc>", "<C-\\><C-n>", opts)

-- Close, write and quit buffers
-- keymap('', '<Leader>c', ':close<CR>', opts)
keymap("", "<Leader>c", ":close<CR>", opts)
keymap("", "<Leader>w", ":w!<CR>", opts)
-- keymap('n', '<Leader>q', ':BufferClose<CR>', opts)
keymap("", "<Leader>q", ":bp <BAR> bd #<CR>", opts)

-- Indent in visual mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move with CTRL+Meta (Alt)
keymap("n", "<C-m-j>", ":m .+1<CR>==", opts)
keymap("n", "<C-m-k>", ":m .-2<CR>==", opts)
keymap("i", "<C-m-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("i", "<C-m-k>", "<Esc>:m .-2<CR>==gi", opts)
keymap("v", "<C-m-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<C-m-k>", ":m '<-2<CR>gv=gv", opts)

keymap("n", "<Leader>qa", ":qa!<CR>", opts)

-- CTRL+Backspace to delete word
keymap("i", "<C-H>", "<C-W>", opts)

-- jj as escape
keymap("i", "jj", "<ESC>", opts)

keymap("n", "<Leader><space>", ":nohlsearch<CR>",
       {noremap = true, silent = false, expr = false})

keymap("n", "<Leader>pack", ":PackerSync<CR>", opts)

vim.cmd(
    'command! -nargs=0 LspVirtualTextToggle lua require("lsp/virtual_text").toggle()')
