return {
    "j-hui/fidget.nvim",
    lazy = false,
    priority = 1001,
    opts = {
        notification = {
            override_vim_notify = true,
        },
    },
    config = function(_, opts)
        local fidget = require("fidget")
        fidget.setup(opts)
    end,
}
