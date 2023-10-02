return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
        local dashboard = require("alpha.themes.dashboard")
        local logo = [[
                                     .__
              ____   ____  _______  _|__| _____
             /    \_/ __ \/  _ \  \/ /  |/     \
            |   |  \  ___(  <_> )   /|  |  Y Y  \
            |___|  /\___  >____/ \_/ |__|__|_|  /
                 \/     \/                    \/
        ]]
        dashboard.section.header.val = vim.split(logo, "\n")
        dashboard.section.buttons.val = {
            dashboard.button("c", "  Configuration", ":lua require('core.telescope').search_nvim()<CR>"),
            dashboard.button("n", "  Notes", ":lua require('core.telescope').grep_notes()<CR>"),
            dashboard.button("s", "  Restore session", ":lua require('persistence').load()<CR>"),
            dashboard.button("u", "󰃨  Update all", ":UpdateAll<CR>"),
            dashboard.button("q", "󰅚  Quit Neovim", ":qa<CR>"),
        }

        dashboard.section.footer.opts.hl = "Type"
        dashboard.section.header.opts.hl = "Include"
        dashboard.section.buttons.opts.hl = "Keyword"

        dashboard.opts.opts.noautocmd = true
        return dashboard
    end,
    config = function(_, dashboard)
        if vim.o.filetype == "lazy" then
            vim.cmd.close()
            vim.api.nvim_create_autocmd("User", {
                pattern = "AlphaReady",
                callback = function()
                    require("lazy").show()
                end,
            })
        end

        require("alpha").setup(dashboard.opts)

        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyVimStarted",
            callback = function()
                local version = vim.version()

                local stats = require("lazy").stats()
                dashboard.section.footer.val = "⚡ Neovim("
                    .. version.major
                    .. "."
                    .. version.minor
                    .. "."
                    .. version.patch
                    .. ") loaded "
                    .. stats.count
                    .. " plugins "
                pcall(vim.cmd.AlphaRedraw)
            end,
        })
    end,
}
