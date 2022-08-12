local ok, navic = pcall(require, "nvim-navic")
if not ok then
    vim.notify("Unable to require nvim-navic", vim.lsp.log_levels.ERROR,
			   {title = "Plugin error"})
    return
end

navic.setup{
	highlight = true
}
