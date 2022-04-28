local ok, go = pcall(require, "go")
if not ok then
	vim.notify("Unable to require go", vim.lsp.log_levels.ERROR, { title = "Plugin error" })
	return
end

local okformat, goformat = pcall(require, "go.format")
if not okformat then
	vim.notify("Unable to require go.format", vim.lsp.log_levels.ERROR, { title = "Plugin error" })
	return
end

go.setup({ dap_debug = true, dap_debug_gui = true })

-- Run gofmt + goimport on save
vim.api.nvim_create_autocmd({"BufWritePre"}, {pattern = "*.go", callback = function() goformat.goimport() end})

