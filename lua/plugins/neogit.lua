return {
    "NeogitOrg/neogit",
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
            desc = "Neogit"
        }
    }
}
