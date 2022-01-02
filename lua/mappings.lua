local api = vim.api
-- local cmd = vim.cmd

-- Easy navigation
api.nvim_set_keymap("n", "<C-h>", " <C-W>h", {})
api.nvim_set_keymap("n", "<C-j>", " <C-W>j", {})
api.nvim_set_keymap("n", "<C-k>", " <C-W>k", {})
api.nvim_set_keymap("n", "<C-l>", " <C-W>l", {})

api.nvim_set_keymap("n", "fn", "]m", {})
api.nvim_set_keymap("n", "fp", "[m", {})

api.nvim_set_keymap("n", "<C-p>", ":BufferLineCyclePrev<CR>", {})
api.nvim_set_keymap("n", "<C-n>", ":BufferLineCycleNext<CR>", {})

api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", {noremap = true})

-- Close, write and quit buffers
-- api.nvim_set_keymap('', '<Leader>c', ':close<CR>', {})
api.nvim_set_keymap("", "<Leader>c", ":close<CR>", {})
api.nvim_set_keymap("", "<Leader>w", ":w!<CR>", {})
-- api.nvim_set_keymap('n', '<Leader>q', ':BufferClose<CR>', {})
api.nvim_set_keymap("", "<Leader>q", ":bp <BAR> bd #<CR>", {})

api.nvim_set_keymap("", "<Leader>t", ":terminal<CR>", {})

-- Indent in visual mode
api.nvim_set_keymap("v", "<", "<gv", {})
api.nvim_set_keymap("v", ">", ">gv", {})

-- Move with CTRL+Meta (Alt)
api.nvim_set_keymap("n", "<C-m-j>", ":m .+1<CR>==", {noremap = true})
api.nvim_set_keymap("n", "<C-m-k>", ":m .-2<CR>==", {noremap = true})
api.nvim_set_keymap("i", "<C-m-j>", "<Esc>:m .+1<CR>==gi", {noremap = true})
api.nvim_set_keymap("i", "<C-m-k>", "<Esc>:m .-2<CR>==gi", {noremap = true})
api.nvim_set_keymap("v", "<C-m-j>", ":m '>+1<CR>gv=gv", {noremap = true})
api.nvim_set_keymap("v", "<C-m-k>", ":m '<-2<CR>gv=gv", {noremap = true})

api.nvim_set_keymap("n", "<Leader>qa", ":qa!<CR>", {noremap = true})

-- CTRL+Backspace to delete word
api.nvim_set_keymap("i", "<C-H>", "<C-W>", {noremap = true})

-- jj as escape
api.nvim_set_keymap("i", "jj", "<ESC>", {})

api.nvim_set_keymap("n", "<Leader><space>", ":nohlsearch<CR>",
                    {noremap = true, silent = false, expr = false})

-- {{ Telescope
api.nvim_set_keymap("n", "<Leader>a",
                    ':lua require("telescope.builtin").marks()<CR>', {})
api.nvim_set_keymap("n", "<Leader>ff",
                    ':lua require("telescope.builtin").find_files({hidden=true})<CR>',
                    {})
api.nvim_set_keymap("n", "<Leader>fv",
                    ':lua require("telescope.builtin").treesitter()<CR>', {})
api.nvim_set_keymap("n", "<Leader>fm",
                    ':lua require("telescope").extensions.media_files.media_files()<CR>',
                    {})
api.nvim_set_keymap("n", "<Leader>fg",
                    ':lua require("telescope.builtin").live_grep()<CR>', {})
api.nvim_set_keymap("n", "<Leader>fb",
                    ':lua require("telescope.builtin").buffers()<CR>', {})
api.nvim_set_keymap("n", "<Leader>fh",
                    ':lua require("telescope.builtin").help_tags()<CR>', {})
api.nvim_set_keymap("n", "<Leader>fo",
                    ':lua require("telescope.builtin").tags{ only_current_buffer = true }<CR>',
                    {})
api.nvim_set_keymap("n", "<Leader>vrc",
                    ':lua require("config.telescope").search_nvim()<CR>',
                    {noremap = true})
api.nvim_set_keymap("n", "<Leader>notes",
                    ':lua require("config.telescope").grep_notes()<CR>',
                    {noremap = true})

api.nvim_set_keymap("n", "<Leader>p", ":Telescope diagnostics bufnr=0<CR>", {})
api.nvim_set_keymap("n", "<Leader>s",
                    ':lua require("telescope.builtin").lsp_document_symbols()<CR>',
                    {})
api.nvim_set_keymap("n", "<Leader>bp", ":Telescope neoclip unnamed<CR>", {})
-- }}

-- {{ Focus
api.nvim_set_keymap("n", "<Leader>h", ":FocusSplitLeft<CR>", {silent = true})
api.nvim_set_keymap("n", "<Leader>j", ":FocusSplitDown<CR>", {silent = true})
api.nvim_set_keymap("n", "<Leader>k", ":FocusSplitUp<CR>", {silent = true})
api.nvim_set_keymap("n", "<Leader>l", ":FocusSplitRight<CR>", {silent = true})
-- }}

api.nvim_set_keymap("n", "<Leader>pack", ":PackerSync<CR>", {noremap = true})

-- {{ NvimTree
api.nvim_set_keymap("n", "<Leader>n", ":NvimTreeToggle<CR>", {noremap = true})
api.nvim_set_keymap("n", "<Leader>r", ":NvimTreeRefresh<CR>", {noremap = true})
-- }}

vim.cmd(
    'command! -nargs=0 LspVirtualTextToggle lua require("lsp/virtual_text").toggle()')

-- {{ vsnip
api.nvim_set_keymap("i", "<Tab>",
                    "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'",
                    {expr = true})
api.nvim_set_keymap("s", "<Tab>",
                    "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'",
                    {expr = true})
api.nvim_set_keymap("i", "<S-Tab>",
                    "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'",
                    {expr = true})
api.nvim_set_keymap("s", "<S-Tab>",
                    "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'",
                    {expr = true})
-- }}
