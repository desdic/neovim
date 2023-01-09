return {
    -- comments
    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        dependencies = {"JoosepAlviste/nvim-ts-context-commentstring"},
        config = function()
            require("mini.comment").setup({
                hooks = {pre = function()
                    require("ts_context_commentstring.internal").update_commentstring({})
                end}
            })
        end
    }, -- pairs
    {"echasnovski/mini.pairs", event = "VeryLazy", config = function() require("mini.pairs").setup({}) end},
    -- surround
    {
        "echasnovski/mini.surround",
        event = "VeryLazy",
        config = function()
            require("mini.surround").setup({
                mappings = {
                    add = "gza", -- Add surrounding in Normal and Visual modes
                    delete = "gzd", -- Delete surrounding
                    find = "gzf", -- Find surrounding (to the right)
                    find_left = "gzF", -- Find surrounding (to the left)
                    highlight = "gzh", -- Highlight surrounding
                    replace = "gzr", -- Replace surrounding
                    update_n_lines = "gzn" -- Update `n_lines`
                }
            })
        end
    }, -- bufremove
    {
        "echasnovski/mini.bufremove",
        event = "VeryLazy",
        keys = {
            {"<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "[B]uffer [d]elete"},
            {"<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "[B]uffer [d]elete force"}
        }
    }
}
