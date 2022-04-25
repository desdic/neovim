local ok, tn = pcall(require, "tokyonight")
if not ok then
	vim.notify("Unable to require tokyonight", vim.lsp.log_levels.ERROR, { title = "Plugin error" })
	return
end

vim.cmd([[colorscheme tokyonight]])
vim.g.tokyonight_style = "storm"
