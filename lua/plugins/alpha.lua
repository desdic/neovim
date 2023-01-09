local M = {"goolord/alpha-nvim", lazy = false}

local function show()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
        [[                         .__          ]], [[  ____   ____  _______  _|__| _____   ]],
        [[ /    \_/ __ \/  _ \  \/ /  |/     \  ]], [[|   |  \  ___(  <_> )   /|  |  Y Y  \ ]],
        [[|___|  /\___  >____/ \_/ |__|__|_|  / ]], [[     \/     \/                    \/  ]]
    }

    dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
        dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
        dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", "  Configuration", ":lua require('custom.telescope').search_nvim()<CR>"),
        dashboard.button("u", "  Update plugins", ":Lazy sync<CR>"),
        dashboard.button("n", "  Notes", ":lua require('custom.telescope').grep_notes()<CR>"),
        dashboard.button("h", "  Harpoon", ":Telescope harpoon marks<CR>"),
        dashboard.button("m", "  Mason", ":Mason<CR>"), dashboard.button("q", "  Quit Neovim", ":qa<CR>")
    }

    local lazystats = require("lazy").stats()
    dashboard.section.footer.val = lazystats.loaded .. "/" .. lazystats.count .. " plugins  " ..
                                       (math.floor(lazystats.startuptime * 100 + 0.5) / 100) .. "ms"

    dashboard.section.footer.opts.hl = "Type"
    dashboard.section.header.opts.hl = "Include"
    dashboard.section.buttons.opts.hl = "Keyword"

    dashboard.opts.opts.noautocmd = true
    alpha.setup(dashboard.opts)
end

function M.config()
    vim.api.nvim_create_autocmd("User", {pattern = "LazyVimStarted", callback = function() show() end})
    show()
end

return M
