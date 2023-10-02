return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "VeryLazy" },
    config = function()
        require('ibl').setup({
            indent = { char = "│", tab_char = "▸" },
            -- config = {exclude = { "help", "alpha", "lazy", "mason" }},
            scope = {
                enabled = false,
            },
        })
        local hooks = require "ibl.hooks"
        hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
}
