local ok, ntree = pcall(require, "nvim-tree")
if not ok then
	vim.notify("Unable to require nvim-tree", vim.lsp.log_levels.ERROR, { title = "Plugin error" })
	return
end

ntree.setup()

vim.keymap.set("n", "<Leader>n", ":NvimTreeToggle<CR>", { noremap = true, silent = true, desc = "Show nvim tree" })
vim.keymap.set("n", "<Leader>r", ":NvimTreeRefresh<CR>", { noremap = true, silent = true, desc = "Refresh nvim tree" })
