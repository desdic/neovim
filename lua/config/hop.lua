local lsok, hop = pcall(require, "hop")
if not lsok then
    vim.notify("Unable to require hop")
    return
end

hop.setup({
	-- jump_on_sole_occurrence = false,
})

local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}
keymap("n", "s", ":HopChar1<CR>", opts)
keymap("n", "hw", "<cmd>lua require'hop'.hint_words()<cr>", opts)
keymap("n", "hl", ":HopLine<CR>", opts)
