local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	vim.notify("Unable to require alpha", vim.lsp.log_levels.ERROR, { title = "Plugin error" })
	return
end

local dashok, dashboard = pcall(require, "alpha.themes.dashboard")
if not dashok then
	vim.notify("Unable to require alpha.themes.dashboard", vim.lsp.log_levels.ERROR, { title = "Plugin error" })
	return
end

dashboard.section.header.val = {
	[[                         .__          ]],
	[[  ____   ____  _______  _|__| _____   ]],
	[[ /    \_/ __ \/  _ \  \/ /  |/     \  ]],
	[[|   |  \  ___(  <_> )   /|  |  Y Y  \ ]],
	[[|___|  /\___  >____/ \_/ |__|__|_|  / ]],
	[[     \/     \/                    \/  ]],
}

dashboard.section.buttons.val = {
	dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
	dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
	dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
	dashboard.button("c", "  Configuration", ":lua require('config.telescope').search_nvim()<CR>"),
	dashboard.button("u", "  Update plugins", ":PackerSync<CR>"),
	dashboard.button("n", "  Notes", ":lua require('config.telescope').grep_notes()<CR>"),
	-- dashboard.button("p", "  Projects", ":Telescope projects<CR>"),
	dashboard.button("h", "  Harpoon", ":Telescope harpoon marks<CR>"),
	dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}

local plugin_dir = string.format("%s/site/pack/packer/start/", vim.fn.stdpath("data"))
local total_plugins = vim.fn.len(vim.fn.globpath(plugin_dir, "*", 0, 1))
dashboard.section.footer.val = "Loaded " .. total_plugins .. " plugins  "

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
