local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

-- Easy navigation
keymap("n", "<C-h>", " <C-W>h", opts)
keymap("n", "<C-j>", " <C-W>j", opts)
keymap("n", "<C-k>", " <C-W>k", opts)
keymap("n", "<C-l>", " <C-W>l", opts)

keymap("n", "fn", "]m", opts)
keymap("n", "fp", "[m", opts)

keymap("n", "<C-p>", ":BufferLineCyclePrev<CR>", opts)
keymap("n", "<C-n>", ":BufferLineCycleNext<CR>", opts)

keymap("t", "<Esc>", "<C-\\><C-n>", opts)

-- Close, write and quit buffers
-- keymap('', '<Leader>c', ':close<CR>', opts)
keymap("", "<Leader>c", ":close<CR>", opts)
keymap("", "<Leader>w", ":w!<CR>", opts)
-- keymap('n', '<Leader>q', ':BufferClose<CR>', opts)
keymap("", "<Leader>q", ":bp <BAR> bd #<CR>", opts)

keymap("", "<Leader>t", ":terminal<CR>", opts)

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

-- {{ Telescope
keymap("n", "<Leader>a", ':lua require("telescope.builtin").marks()<CR>', opts)
keymap("n", "<Leader>ff",
       ':lua require("telescope.builtin").find_files({hidden=true})<CR>', opts)
keymap("n", "<Leader>fv", ':lua require("telescope.builtin").treesitter()<CR>',
       opts)
keymap("n", "<Leader>fm",
       ':lua require("telescope").extensions.media_files.media_files()<CR>',
       opts)
keymap("n", "<Leader>fg", ':lua require("telescope.builtin").live_grep()<CR>',
       opts)
keymap("n", "<Leader>fb", ':lua require("telescope.builtin").buffers()<CR>',
       opts)
keymap("n", "<Leader>fh", ':lua require("telescope.builtin").help_tags()<CR>',
       opts)
keymap("n", "<Leader>fn",
       ':lua require("telescope").extensions.notify.notify({})<CR>', opts)
keymap("n", "<Leader>fo",
       ':lua require("telescope.builtin").tags{ only_current_buffer = true }<CR>',
       opts)
keymap("n", "<Leader>vrc", ':lua require("config.telescope").search_nvim()<CR>',
       opts)
keymap("n", "<Leader>notes",
       ':lua require("config.telescope").grep_notes()<CR>', opts)

keymap("n", "<Leader>p", ":Telescope diagnostics bufnr=0<CR>", opts)
keymap("n", "<Leader>bp", ":Telescope neoclip unnamed<CR>", opts)
-- }}

-- {{ Focus
keymap("n", "<Leader>h", ":FocusSplitLeft<CR>", opts)
keymap("n", "<Leader>j", ":FocusSplitDown<CR>", opts)
keymap("n", "<Leader>k", ":FocusSplitUp<CR>", opts)
keymap("n", "<Leader>l", ":FocusSplitRight<CR>", opts)
-- }}

keymap("n", "<Leader>pack", ":PackerSync<CR>", opts)

-- {{ NvimTree
keymap("n", "<Leader>n", ":NvimTreeToggle<CR>", opts)
keymap("n", "<Leader>r", ":NvimTreeRefresh<CR>", opts)
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
