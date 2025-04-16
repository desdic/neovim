return {
    "saghen/blink.cmp",
    event = { "LspAttach" },

    dependencies = {
        {
            "folke/lazydev.nvim",
            opts = {
                library = { "nvim-dap-ui" },
            },
            config = function(_, opts)
                require("lazydev").setup(opts)
            end,
        },
        "L3MON4D3/LuaSnip",
    },

    -- use a release tag to download pre-built binaries
    version = "v0.*",

    opts = {
        keymap = {
            preset = "default",
            ["<CR>"] = { "select_and_accept", "fallback" },
        },

        -- don't use in gitcommits or dressings input box
        enabled = function()
            return not vim.tbl_contains({ "gitcommit", "DressingInput" }, vim.bo.filetype)
                and vim.bo.buftype ~= "prompt"
                and vim.b.completion ~= false
        end,

        completion = {
            documentation = {
                auto_show = true,
                window = {
                    border = "rounded",
                },
            },
            ghost_text = {
                enabled = false,
            },
            menu = {
                border = "rounded",
                draw = {
                    columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
                    treesitter = { "lsp" },
                },
            },
            list = {
                selection = {
                    preselect = true,
                    auto_insert = true,
                },
            },
        },

        snippets = {
            preset = "luasnip",
        },

        cmdline = { enabled = false },

        sources = {
            default = { "lsp", "snippets", "buffer", "lazydev" },
            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    min_keyword_length = 3,
                },
                lsp = {
                    min_keyword_length = 3,
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
    opts_extend = { "sources.completion.enabled_providers" },
}
