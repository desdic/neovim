local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
    vim.notify("Unable to require alpha", "error")
    return
end

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
    [[                         .__          ]],
    [[  ____   ____  _______  _|__| _____   ]],
    [[ /    \_/ __ \/  _ \  \/ /  |/     \  ]],
    [[|   |  \  ___(  <_> )   /|  |  Y Y  \ ]],
    [[|___|  /\___  >____/ \_/ |__|__|_|  / ]],
    [[     \/     \/                    \/  ]]
}
dashboard.section.buttons.val = {
    dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
    dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
    dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
    dashboard.button("c", "  Configuration",
                     ":e ~/.config/nvim/init.lua <CR>"),
    dashboard.button("q", "  Quit Neovim", ":qa<CR>")
}

local function footer() return "" end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
