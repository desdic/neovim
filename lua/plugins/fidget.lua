return {
    "j-hui/fidget.nvim",
    -- event = { "BufReadPre", "BufNewFile" },
    lazy = false,
    priority = 1001,
    opts = {
        notification = {
            filter = vim.log.levels.DEBUG,
        },
    },
    config = function(_, opts)
        local fidget = require("fidget")
        fidget.setup(opts)
        vim.notify = fidget.notify
    end,
}
