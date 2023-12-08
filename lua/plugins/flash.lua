return {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
        search = {
            filetype_exclude = { "notify" },
        },
        modes = {
            search = {
                enabled = false, -- disable for search
            },
            char = {
                enabled = false, -- disable for fFtT
            },
        },
        label = {
            rainbow = {
                enabled = true,
            },
        },
    },
    keys = {
        {
            "s",
            mode = { "n", "x", "o" },
            function()
                require("flash").jump()
            end,
            desc = "Flash",
        },
        {
            "S",
            mode = { "n", "x", "o" },
            function()
                require("flash").treesitter()
            end,
            desc = "Flash Treesitter",
        },
        {
            "r",
            mode = "o",
            function()
                require("flash").remote()
            end,
            desc = "Remote Flash",
        },
        {
            "R",
            mode = { "o", "x" },
            function()
                require("flash").treesitter_search()
            end,
            desc = "Treesitter Search",
        }
    },
}
