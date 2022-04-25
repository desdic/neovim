local ok, nightfox = pcall(require, "nightfox")
if not ok then
	vim.notify("Unable to require nightfox", vim.lsp.log_levels.ERROR, { title = "Plugin error" })
	return
end

nightfox.setup({
	options = {
		-- Compiled file's destination location
		transparent = false, -- Disable setting background
		terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*)
		dim_inactive = true, -- Non focused panes set to alternative background
		styles = { -- Style to be applied to different syntax groups
			comments = "italic",
			functions = "italic,bold",
			keywords = "bold",
			numbers = "NONE",
			strings = "NONE",
			types = "NONE",
			variables = "NONE",
		},
		inverse = { -- Inverse highlight for different types
			match_paren = true,
			visual = true,
			search = true,
		},
	},
})

vim.cmd("colorscheme nightfox")
