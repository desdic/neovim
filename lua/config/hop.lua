local lsok, hop = pcall(require, "hop")
if not lsok then
    vim.notify("Unable to require hop")
    return
end

hop.setup({
	-- jump_on_sole_occurrence = false,
})

local keymap = vim.api.nvim_set_keymap
local opts = {}

keymap('n', 's', "<cmd>lua require'hop'.hint_char1()<CR>", opts)
keymap('n', 'F', "<cmd>lua require'hop'.hint_words()<CR>", opts)

keymap('o', 's', "<cmd>lua require'hop'.hint_char1({ inclusive_jump = true })<CR>", opts)
keymap('o', 'F', "<cmd>lua require'hop'.hint_words({ inclusive_jump = true })<CR>", opts)

keymap('v', 's', "<cmd>lua require'hop'.hint_words({ inclusive_jump = true })<CR>", opts)
keymap("n", "<Leader>hl", "<cmd>lua require'hop'.hint_lines()<CR>", opts)
