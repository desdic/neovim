return {
    "saghen/blink.cmp",
    event = { "LspAttach" },

    dependencies = { "folke/lazydev.nvim", "L3MON4D3/LuaSnip" },

    -- use a release tag to download pre-built binaries
    version = "v0.*",

    opts = {
        keymap = {
            preset = "default",
            ["<CR>"] = { "select_and_accept", "fallback" },
            cmdline = {
                preset = "enter",
            },
        },

        -- don't use in gitcommits or dressings input box
        enabled = function()
            return not vim.tbl_contains({ "gitcommit", "DressingInput" }, vim.bo.filetype)
                and vim.bo.buftype ~= "prompt"
                and vim.b.completion ~= false
        end,

        completion = {
            keyword = { range = "full" },
            accept = {
                auto_brackets = { enabled = true },
            },
            documentation = {
                auto_show = true,
                window = {
                    border = "rounded",
                },
            },
            ghost_text = {
                enabled = true,
            },
            menu = {
                auto_show = function(ctx)
                    return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
                end,
                border = "rounded",
                draw = {
                    columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
                    treesitter = { "lsp" },
                },
            },
            list = {
                selection = {
                    -- Skip preselection in cmdline
                    preselect = function(ctx)
                        return ctx.mode ~= "cmdline"
                    end,
                    auto_insert = true,
                },
            },
        },

        snippets = {
            preset = "luasnip",
        },

        sources = {
            default = { "lsp", "snippets", "buffer", "lazydev" },
            -- cmdline = {},
            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    min_keyword_length = 3,
                },
                lsp = {
                    min_keyword_length = 3,
                    max_items = 20,
                    fallbacks = { "buffer", "lazydev" },
                },
                snippets = {
                    min_keyword_length = 3,
                },
                buffer = {
                    min_keyword_length = 3,
                },
                cmdline = {
                    min_keyword_length = 2,
                },
            },
        },

        -- signature = { enabled = true },

        appearance = {
            -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = "mono",
        },
    },
    opts_extend = { "sources.completion.enabled_providers" },
}
