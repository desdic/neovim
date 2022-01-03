local keymap = vim.api.nvim_set_keymap

-- Easy navigation
keymap("n", "<C-h>", " <C-W>h", {})
keymap("n", "<C-j>", " <C-W>j", {})
keymap("n", "<C-k>", " <C-W>k", {})
keymap("n", "<C-l>", " <C-W>l", {})

keymap("n", "fn", "]m", {})
keymap("n", "fp", "[m", {})

keymap("n", "<C-p>", ":BufferLineCyclePrev<CR>", {})
keymap("n", "<C-n>", ":BufferLineCycleNext<CR>", {})

keymap("t", "<Esc>", "<C-\\><C-n>", {noremap = true})

-- Close, write and quit buffers
-- keymap('', '<Leader>c', ':close<CR>', {})
keymap("", "<Leader>c", ":close<CR>", {})
keymap("", "<Leader>w", ":w!<CR>", {})
-- keymap('n', '<Leader>q', ':BufferClose<CR>', {})
keymap("", "<Leader>q", ":bp <BAR> bd #<CR>", {})

keymap("", "<Leader>t", ":terminal<CR>", {})

-- Indent in visual mode
keymap("v", "<", "<gv", {})
keymap("v", ">", ">gv", {})

-- Move with CTRL+Meta (Alt)
keymap("n", "<C-m-j>", ":m .+1<CR>==", {noremap = true})
keymap("n", "<C-m-k>", ":m .-2<CR>==", {noremap = true})
keymap("i", "<C-m-j>", "<Esc>:m .+1<CR>==gi", {noremap = true})
keymap("i", "<C-m-k>", "<Esc>:m .-2<CR>==gi", {noremap = true})
keymap("v", "<C-m-j>", ":m '>+1<CR>gv=gv", {noremap = true})
keymap("v", "<C-m-k>", ":m '<-2<CR>gv=gv", {noremap = true})

keymap("n", "<Leader>qa", ":qa!<CR>", {noremap = true})

-- CTRL+Backspace to delete word
keymap("i", "<C-H>", "<C-W>", {noremap = true})

-- jj as escape
keymap("i", "jj", "<ESC>", {})

keymap("n", "<Leader><space>", ":nohlsearch<CR>",
       {noremap = true, silent = false, expr = false})

-- {{ Telescope
keymap("n", "<Leader>a", ':lua require("telescope.builtin").marks()<CR>', {})
keymap("n", "<Leader>ff",
       ':lua require("telescope.builtin").find_files({hidden=true})<CR>', {})
keymap("n", "<Leader>fv", ':lua require("telescope.builtin").treesitter()<CR>',
       {})
keymap("n", "<Leader>fm",
       ':lua require("telescope").extensions.media_files.media_files()<CR>', {})
keymap("n", "<Leader>fg", ':lua require("telescope.builtin").live_grep()<CR>',
       {})
keymap("n", "<Leader>fb", ':lua require("telescope.builtin").buffers()<CR>', {})
keymap("n", "<Leader>fh", ':lua require("telescope.builtin").help_tags()<CR>',
       {})
keymap("n", "<Leader>fo",
       ':lua require("telescope.builtin").tags{ only_current_buffer = true }<CR>',
       {})
keymap("n", "<Leader>vrc", ':lua require("config.telescope").search_nvim()<CR>',
       {noremap = true})
keymap("n", "<Leader>notes",
       ':lua require("config.telescope").grep_notes()<CR>', {noremap = true})

keymap("n", "<Leader>p", ":Telescope diagnostics bufnr=0<CR>", {})
keymap("n", "<Leader>bp", ":Telescope neoclip unnamed<CR>", {})
-- }}

-- {{ Focus
keymap("n", "<Leader>h", ":FocusSplitLeft<CR>", {silent = true})
keymap("n", "<Leader>j", ":FocusSplitDown<CR>", {silent = true})
keymap("n", "<Leader>k", ":FocusSplitUp<CR>", {silent = true})
keymap("n", "<Leader>l", ":FocusSplitRight<CR>", {silent = true})
-- }}

keymap("n", "<Leader>pack", ":PackerSync<CR>", {noremap = true})

-- {{ NvimTree
keymap("n", "<Leader>n", ":NvimTreeToggle<CR>", {noremap = true})
keymap("n", "<Leader>r", ":NvimTreeRefresh<CR>", {noremap = true})
-- }}

vim.cmd(
    'command! -nargs=0 LspVirtualTextToggle lua require("lsp/virtual_text").toggle()')

-- {{ vsnip
keymap("i", "<Tab>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'",
       {expr = true})
keymap("s", "<Tab>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'",
       {expr = true})
keymap("i", "<S-Tab>",
       "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'",
       {expr = true})
keymap("s", "<S-Tab>",
       "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'",
       {expr = true})
-- }}
