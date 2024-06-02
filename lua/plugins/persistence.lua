return {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = { options = vim.opt.sessionoptions:get() },
    keys = {
        {
            "<leader>qq",
            function()
                require("persistence").load()
            end,
            desc = "Restore Session",
        },
        {
            "<leader>ql",
            function()
                require("persistence").load({ last = true })
            end,
            desc = "Restore Last Session",
        },
        {
            "<leader>qd",
            function()
                require("persistence").stop()
            end,
            desc = "Don't Save Current Session",
        },
    },
}
