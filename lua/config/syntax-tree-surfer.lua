local status_ok, stf = pcall(require, "syntax-tree-surfer")
if not status_ok then
	vim.notify("Unable to require syntax-tree-surfer", vim.lsp.log_levels.ERROR, { title = "Plugin error" })
	return
end

stf.setup({
	default_desired_types = {
		"function",
		"function_definition",
		"identifier",
		"variable_declaration",
		"if_statement",
		"else_clause",
		"else_statement",
		"elseif_statement",
		"for_statement",
		"while_statement",
		"switch_statement",
	}
})

local opts = {noremap = true, silent = true}

-- To find treesitter declarations use :TSPlaygroundToggle
--
vim.keymap.set("n", "gv", function()
	stf.targeted_jump({ "variable_declaration", "identifier" })
end, opts)

vim.keymap.set("n", "gf", function()
	stf.targeted_jump({ "function", "function_definition", "function_declaration" })
end, opts)

vim.keymap.set("n", "vx", function()
	stf.select()
end, opts)

vim.keymap.set("n", "vn", function()
	stf.select_current_node()
end, opts)
