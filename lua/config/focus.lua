local ok, focus = pcall(require, "focus")
if not ok then
	vim.notify("Unable to require focus", vim.lsp.log_levels.ERROR, { title = "Plugin error" })
	return
end

focus.setup({
	enable = true,
	cursorline = false,
	signcolumn = true,
	number = false,
	excluded_filetypes = { "toggleterm" },
})

vim.keymap.set("n", "<Leader>h", function()
	focus.split_command("h")
end, { noremap = true, silent = true, desc = "Split left" })

vim.keymap.set("n", "<Leader>j", function()
	focus.split_command("j")
end, { noremap = true, silent = true, desc = "Split down" })

vim.keymap.set("n", "<Leader>k", function()
	focus.split_command("k")
end, { noremap = true, silent = true, desc = "Split up" })

vim.keymap.set("n", "<Leader>l", function()
	focus.split_command("l")
end, { noremap = true, silent = true, desc = "Split right" })
