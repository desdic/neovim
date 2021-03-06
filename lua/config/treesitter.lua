local ok, ntconfig = pcall(require, "nvim-treesitter.configs")
if not ok then
	vim.notify("Unable to require nvim-treesitter.configs", vim.lsp.log_levels.ERROR, { title = "Plugin error" })
	return
end

ntconfig.setup({
	ensure_installed = {
		"bash",
		"c",
		"cpp",
		"dockerfile",
		"go",
		"json",
		"lua",
		"python",
		"ruby",
		"yaml",
		"toml",
		"markdown",
		"markdown_inline",
		"glsl"
	},
	ignore_install = { "javascript", "haskell" }, -- List of parsers to ignore installing
	indent = { enable = true, disable = {} },
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "rust" }, -- list of language that will be disabled
	},
	rainbow = {
		enable = true,
		extended = true,
		max_file_lines = 5000, -- Do not enable for files with more than 5000 lines, int
	},
	refactor = {
		smart_rename = {
			enable = true,
			keymaps = {
				smart_rename = "grr"
			}
		}
	},
	textobjects = {
		select = {
			enable = true,

			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,

			keymaps = {
				["ff"] = "@function.outer",
				["fb"] = "@block.inner",
				["fc"] = "@class.outer",
				["fl"] = "@loop.outer",
				["if"] = "@function.inner",
				["ic"] = "@class.inner",
				["il"] = "@loop.inner",
				["fi"] = "@conditional.inner",
			},
		},
		swap = {
			enable = true,
			swap_next = { ["fa"] = "@parameter.inner" },
			swap_previous = { ["fA"] = "@parameter.inner" },
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["ff"] = "@function.outer",
				["fb"] = "@block.inner",
				["fc"] = "@class.outer",
				["fl"] = "@loop.outer",
				["fi"] = "@conditional.outer",
				["fp"] = "@parameter.inner",
				["fo"] = "@call.outer",
			},
			goto_previous_start = {
				["FF"] = "@function.outer",
				["Fb"] = "@block.inner",
				["Fc"] = "@class.outer",
				["Fl"] = "@loop.outer",
				["Fi"] = "@conditional.outer",
				["Fp"] = "@parameter.inner",
				["Fo"] = "@call.outer",
			},
			goto_next_end = {
				["fF"] = "@function.outer",
				["fB"] = "@block.inner",
				["fC"] = "@class.outer",
				["fL"] = "@loop.outer",
				["fP"] = "@parameter.inner",
			},
		},
	},
	playground = {
		enable = true,
		disable = {},
		updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
		persist_queries = false, -- Whether the query persists across vim sessions
		keybindings = {
			toggle_query_editor = "o",
			toggle_hl_groups = "i",
			toggle_injected_languages = "t",
			toggle_anonymous_nodes = "a",
			toggle_language_display = "I",
			focus_language = "f",
			unfocus_language = "F",
			update = "R",
			goto_node = "<cr>",
			show_help = "?",
		},
	},
	context_commentstring = { enable = true },
})
