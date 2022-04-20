vim.keymap.set("n", "<C-h>", "<C-W>h", { silent = true, noremap = true, desc = "Move to window on left" })
vim.keymap.set("n", "<C-j>", "<C-W>j", { silent = true, noremap = true, desc = "Move to window below" })
vim.keymap.set("n", "<C-k>", "<C-W>k", { silent = true, noremap = true, desc = "Move to window above" })
vim.keymap.set("n", "<C-l>", "<C-W>l", { silent = true, noremap = true, desc = "Move to window on right" })

vim.keymap.set("n", "<S-l>", ":bnext<CR>", { silent = true, noremap = true, desc = "Move to next buffer" })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { silent = true, noremap = true, desc = "Move to previous buffer" })

-- vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {silent = true, noremap = true, desc = "Easy escape in terminal mode"})

vim.keymap.set("", "<Leader>c", ":close<CR>", { silent = true, noremap = true, desc = "Close window" })
vim.keymap.set("", "<Leader>w", ":w!<CR>", { silent = true, noremap = true, desc = "Write buffer" })
-- vim.keymap.set("", "<Leader>q", ":br <BAR> bd #<CR>", {silent = true, noremap = true})
vim.keymap.set("", "<Leader>q", ":bd<CR>", { silent = true, noremap = true, desc = "Close buffer" })

vim.keymap.set("v", "<", "<gv", { silent = true, noremap = true, desc = "Align to left" })
vim.keymap.set("v", ">", ">gv", { silent = true, noremap = true, desc = "Align to right" })

vim.keymap.set("n", "<C-m-j>", ":m .+1<CR>==", { silent = true, noremap = true })
vim.keymap.set("n", "<C-m-k>", ":m .-2<CR>==", { silent = true, noremap = true })
vim.keymap.set("i", "<C-m-j>", "<Esc>:m .+1<CR>==gi", { silent = true, noremap = true })
vim.keymap.set("i", "<C-m-k>", "<Esc>:m .-2<CR>==gi", { silent = true, noremap = true })
vim.keymap.set("v", "<C-m-j>", ":m '>+1<CR>gv=gv", { silent = true, noremap = true })
vim.keymap.set("v", "<C-m-k>", ":m '<-2<CR>gv=gv", { silent = true, noremap = true })

vim.keymap.set("n", "<Leader>qa", ":qa!<CR>", { silent = true, noremap = true, desc = "Quit" })

vim.keymap.set("i", "<C-H>", "<C-W>", { silent = true, noremap = true, desc = "Delete word backwards" })

-- jk as escape
vim.keymap.set("i", "jk", "<ESC>", { silent = true, noremap = true, desc = "Escape in insert mode" })

vim.keymap.set(
	"n",
	"<Leader><space>",
	":nohlsearch<CR>",
	{ noremap = true, silent = false, expr = false, desc = "Remove search" }
)

vim.keymap.set("n", "<Leader>pack", ":PackerSync<CR>", { silent = true, noremap = true, desc = "Run PackerSync" })

vim.cmd('command! -nargs=0 LspVirtualTextToggle lua require("lsp/virtual_text").toggle()')

vim.keymap.set("n", "<Leader>r", ":e!<CR>", { silent = true, noremap = true, desc = "Reload file" })
