vim.pack.add({
    { src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("v2.*") },
}, { confirm = false })

vim.defer_fn(function()
    local ls = require("luasnip")

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

    vim.keymap.set("i", "<C-e>", function()
        ls.expand()
    end, { desc = "expand snippet" })
    vim.keymap.set({ "i", "s" }, "<C-j>", function()
        ls.jump(1)
    end, { desc = "next placeholder" })
    vim.keymap.set({ "i", "s" }, "<C-k>", function()
        ls.jump(-1)
    end, { desc = "previous placeholder" })

    vim.keymap.set({ "i", "s", "n" }, "<esc>", function()
        if require("luasnip").expand_or_jumpable() then
            require("luasnip").unlink_current()
        end
        vim.cmd("noh")
        return "<esc>"
    end, { desc = "Escape, clear hlsearch, and stop snippet session", expr = true })

    vim.api.nvim_create_autocmd({ "PackChanged" }, {
        group = vim.api.nvim_create_augroup("LuaSnippetsUpdated", { clear = true }),
        callback = function(args)
            local spec = args.data.spec
            if spec and spec.name == "luasnip" and args.data.kind == "update" then
                vim.notify("luasnippets was updated, running make install_jsregexp", vim.log.levels.INFO)
                vim.schedule(function()
                    vim.cmd("make install_jsregexp")
                end)
            end
        end,
    })
end, 500)
