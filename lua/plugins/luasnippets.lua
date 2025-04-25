return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",

    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
        local ls = require("luasnip")

        -- require("luasnip.loaders.from_vscode").lazy_load()
        ---@diagnostic disable-next-line: assign-type-mismatch
        require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/snippets" })

        require("luasnip.loaders.from_vscode").load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })

        local types = require("luasnip.util.types")

        ls.config.setup({
            -- Prevent jumping to previous snippet
            region_check_events = "InsertEnter",
            update_events = "TextChanged,TextChangedI",
            enable_autosnippets = true,
            ext_opts = {
                [types.choiceNode] = { active = { virt_text = { { "●", "Operator" } } } },
            },
        })

        -- Extend changelog with debchangelog
        ls.filetype_extend("changelog", { "debchangelog" })

        vim.keymap.set({ "i", "s" }, "<C-c>", function()
            if ls.choice_active() then
                ls.change_choice(1)
            end
        end)
    end,
}
