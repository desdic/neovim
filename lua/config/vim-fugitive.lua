
local keymap = vim.api.nvim_set_keymap
local opts = {}

keymap('n', 'gh', ":diffget //3<CR>", opts)
keymap('n', 'gu', ":diffget //2<CR>", opts)
keymap('n', 'gs', ":G<CR>", opts)
