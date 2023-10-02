return {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
        search = {
            filetype_exclude = { "notify" },
        },
        modes = {
            search = {
                enabled = false     -- disable for search
            },
            char = {
                enabled = false     -- disable for fFtT
            }
        }
    },
    keys = {
        {
            "s",
            mode = { "n", "x", "o" },
            function()
                require("flash").jump()
            end,
        },
        {
            "S",
            mode = { "o", "x" },
            function()
                require("flash").treesitter()
            end,
        },
    },
}
