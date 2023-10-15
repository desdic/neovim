return {
    "NeogitOrg/neogit",
    event = { "VeryLazy" },
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    cmd = "Neogit",
    keys = {
        {
            "<Leader>g",
            function()
                local neogit = require("neogit")
                neogit.open({ kind = "vsplit" })
            end,
            desc = "Neogit",
        },
    },
}
