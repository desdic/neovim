local status_ok, dressing = pcall(require, "dressing")
if not status_ok then
	vim.notify("Unable to require dressing", vim.lsp.log_levels.ERROR, { title = "Plugin error" })
	return
end

dressing.setup({})
