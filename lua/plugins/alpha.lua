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
            dashboard.button("c", "  Configuration", ":lua require('custom.telescope').search_nvim()<CR>"),
            dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
            dashboard.button("g", "  Grep text", ":Telescope live_grep <CR>"),
            dashboard.button("h", "  Harpoon", ":Telescope harpoon marks<CR>"),
            dashboard.button("l", "  Lazy", ":Lazy<CR>"), dashboard.button("m", "  Mason", ":Mason<CR>"),
            dashboard.button("n", "  Notes", ":lua require('custom.telescope').grep_notes()<CR>"),
            dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
            dashboard.button("u", "  Update plugins", ":Lazy sync<CR>"),
            dashboard.button("q", "  Quit Neovim", ":qa<CR>")
        }

        local lazystats = require("lazy").stats()
        dashboard.section.footer.val = lazystats.loaded .. "/" .. lazystats.count .. " plugins  " ..
            (math.floor(lazystats.startuptime * 100 + 0.5) / 100) .. "ms"

        dashboard.section.footer.opts.hl = "Type"
        dashboard.section.header.opts.hl = "Include"
        dashboard.section.buttons.opts.hl = "Keyword"

        dashboard.opts.opts.noautocmd = true
        return dashboard
    end,
    config = function(_, dashboard)
        if vim.o.filetype == "lazy" then
            vim.cmd.close()
            vim.api.nvim_create_autocmd("User",
                { pattern = "AlphaReady", callback = function() require("lazy").show() end })
        end

        require("alpha").setup(dashboard.opts)

        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyVimStarted",
            callback = function()
                local stats = require("lazy").stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
                pcall(vim.cmd.AlphaRedraw)
            end
        })
    end
}
