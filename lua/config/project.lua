local status_ok, project = pcall(require, "project_nvim")
if not status_ok then
	vim.notify("Unable to require project_nvim", vim.lsp.log_levels.ERROR, { title = "Plugin error" })
	return
end

project.setup({
	-- NOTE: lsp detection will get annoying with multiple langs in one project
	detection_methods = { "pattern" },
	patterns = { ".git", "Makefile", "go.sum", "go.mod" },
})

local tele_status_ok, telescope = pcall(require, "telescope")
if not tele_status_ok then
	return
end

telescope.load_extension("projects")
