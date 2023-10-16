return {
    "L3MON4D3/LuaSnip", -- snippet completions
    dependencies = {
        "rafamadriz/friendly-snippets", -- collection of snippets
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
    build = "make install_jsregexp",
    config = function()
        local ls = require("luasnip")

        local lsloader = require("luasnip.loaders.from_lua")

        lsloader.load({ paths = "~/.config/nvim/snippets" })

        local types = require("luasnip.util.types")

        ls.config.set_config({
            -- Keep last snippet to jump around
            -- history = true,

            -- Enable dynamic snippets
            updateevents = "TextChanged,TextChangedI",
            -- For cleaning up snippets whose text was deleted
            delete_check_events = "TextChanged",

            enable_autosnippets = true,

            ext_opts = {
                -- [types.insertNode] = {active = {virt_text = {{"●", "DiffAdd"}}}},
                [types.choiceNode] = { active = { virt_text = { { "●", "Operator" } } } },
            },
        })

        -- Extend changelog with debchangelog
        ls.filetype_extend("changelog", { "debchangelog" })

        vim.keymap.set({ "i", "s" }, "<c-j>", function()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end, { silent = true })

        vim.keymap.set({ "i", "s" }, "<c-k>", function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end, { silent = true })

        vim.keymap.set("i", "<c-l>", function()
            if ls.choice_active() then
                ls.change_choice(1)
            end
        end)
    end,
}
