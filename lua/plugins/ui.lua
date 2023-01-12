return {
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        config = function()
            local notify = require("notify")

            notify.setup({
                background_colour = "#000000",
                timeout = 1000,
                level = vim.log.levels.INFO,
                fps = 20,
                max_height = function() return math.floor(vim.o.lines * 0.75) end,
                max_width = function() return math.floor(vim.o.columns * 0.75) end
            })

            vim.notify = notify
        end
    }, {
        "stevearc/dressing.nvim",
        event = "VeryLazy",

        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({plugins = {"dressing.nvim"}})
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({plugins = {"dressing.nvim"}})
                return vim.ui.input(...)
            end
        end
    }, {"luukvbaal/stabilize.nvim", event = "VeryLazy", opts = {}}, {
        "beauwilliams/focus.nvim",
        opts = {
            enable = true,
            cursorline = false,
            signcolumn = true,
            number = false,
            excluded_filetypes = {"toggleterm"}
        },
        keys = {
            {"<Leader>sl", function() require("focus").split_command("h") end, desc = "[S]plit window [l]eft"},
            {"<Leader>sr", function() require("focus").split_command("l") end, desc = "[S]plit window [r]ight"}
        }
    }, {"kshenoy/vim-signature", event = "BufEnter"}
}
