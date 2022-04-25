local ok, neoclip = pcall(require, "neoclip")
if not ok then
	vim.notify("Unable to require neoclip", vim.lsp.log_levels.ERROR, { title = "Plugin error" })
	return
end

neoclip.setup()

vim.keymap.set(
	"n",
	"<Leader>bp",
	":Telescope neoclip unnamed<CR>",
	{ noremap = true, silent = true, desc = "Show clipboard buffers" }
)
