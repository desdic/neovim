return {
    {
        "echasnovski/mini.bufremove",
        event = "VeryLazy",
        keys = {
            {
                "<leader>bd",
                function()
                    require("mini.bufremove").delete(0, false)
                end,
                desc = "[B]uffer [d]elete",
            },
            {
                "<leader>bD",
                function()
                    require("mini.bufremove").delete(0, true)
                end,
                desc = "[B]uffer [d]elete force",
            },
        },
        config = function()
            require("mini.bufremove").setup()
        end,
    },
    {
        "echasnovski/mini.move",
        event = "BufEnter",
        opts = {
            mappings = {
                -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
                left = "<M-S-h>",
                right = "<M-S-l>",
                down = "<M-S-j>",
                up = "<M-S-k>",

                -- Move current line in Normal mode
                line_left = "<M-S-h>",
                line_right = "<M-S-l>",
                line_down = "<M-S-j>",
                line_up = "<M-S-k>",
            },
        },
        config = function(_, opts)
            require("mini.move").setup(opts)
        end,
    }
}
