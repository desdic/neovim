return {

    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
        {
            "folke/lazydev.nvim",
            opts = {
                library = { "nvim-dap-ui" },
            },
        },
        "L3MON4D3/LuaSnip",
    },
    event = "InsertEnter",
    opts = {
        keymap = {
            ["<CR>"] = { "accept", "fallback" },
            ["<C-\\>"] = { "hide", "fallback" },
            ["<C-n>"] = { "select_next", "snippet_forward", "fallback" },
            ["<C-p>"] = { "select_prev" },
            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },
            ["<C-e>"] = false, -- disable
            ["<C-c>"] = { "cancel", "fallback" },
        },
        -- don't use in gitcommits or prompts
        enabled = function()
            return not vim.tbl_contains({ "gitcommit", "oil" }, vim.bo.filetype)
                and vim.bo.buftype ~= "prompt"
                and vim.b.completion ~= false
        end,
        completion = {
            list = {
                selection = { preselect = true, auto_insert = true },
                max_items = 10,
            },

            menu = {
                border = "rounded",
                draw = {
                    columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
                    treesitter = { "lsp" },
                },
            },
            documentation = { auto_show = true },
        },
        snippets = { preset = "luasnip" },
        cmdline = { enabled = false },
        sources = {
            -- Disable some sources in comments and strings.
            default = function()
                local sources = { "lsp", "buffer", "lazydev" }
                local ok, node = pcall(vim.treesitter.get_node)

                if ok and node then
                    if node:type() ~= "string" then
                        table.insert(sources, "snippets")
                    end
                end

                return sources
            end,

            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                },
                lsp = {
                    -- min_keyword_length = 3,
                    max_items = 10,
                    fallbacks = { "buffer", "lazydev" },
                    score_offset = 4,
                },
                snippets = {
                    min_keyword_length = 2, -- don't show when triggered manually, useful for JSON keys
                    score_offset = 3,
                    max_items = 4,
                    should_show_items = function(ctx)
                        return ctx.trigger.initial_kind ~= "trigger_character"
                    end,
                    opts = {
                        use_show_condition = true,
                        show_autosnippets = false,
                    },
                },
                buffer = {
                    min_keyword_length = 3,
                    score_offset = 2,
                    max_items = 5,
                    should_show_items = function(ctx)
                        return ctx.trigger.initial_kind ~= "trigger_character"
                    end,
                },
            },
        },
    },
    config = function(_, opts)
        require("blink.cmp").setup(opts)

        -- Extend neovim's client capabilities with the completion ones.
        vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(nil, true) })
    end,
}
