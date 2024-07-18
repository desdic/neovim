return {
    "folke/which-key.nvim",
    -- event = { "BufReadPre", "BufNewFile" },
    event = { "VeryLazy" },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
    opts = {
        plugins = {
            marks = false,
            registers = false,
        },
        delay = 1000,
    },
}
