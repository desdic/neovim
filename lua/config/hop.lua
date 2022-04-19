local lsok, hop = pcall(require, "hop")
if not lsok then
    vim.notify("Unable to require hop")
    return
end

hop.setup({
	-- jump_on_sole_occurrence = false,
})

local opts = {}

vim.keymap.set('n', 's', "<cmd>lua require'hop'.hint_char1()<CR>", opts)
vim.keymap.set('n', 'F', "<cmd>lua require'hop'.hint_words()<CR>", opts)

vim.keymap.set('o', 's', "<cmd>lua require'hop'.hint_char1({ inclusive_jump = true })<CR>", opts)
vim.keymap.set('o', 'F', "<cmd>lua require'hop'.hint_words({ inclusive_jump = true })<CR>", opts)

vim.keymap.set('v', 's', "<cmd>lua require'hop'.hint_words({ inclusive_jump = true })<CR>", opts)
vim.keymap.set("n", "<Leader>hl", "<cmd>lua require'hop'.hint_lines()<CR>", opts)
