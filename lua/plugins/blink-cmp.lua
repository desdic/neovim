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
        },

        -- don't use in gitcommits
        enabled = function()
            return not vim.tbl_contains({ "gitcommit" }, vim.bo.filetype)
                and vim.bo.buftype ~= "prompt"
                and vim.b.completion ~= false
        end,

        completion = {
            keyword = { range = "prefix" },
            accept = {
                auto_brackets = { enabled = true },
            },
            documentation = {
                -- Use <C-space> to show documentation
                auto_show = true,
                window = {
                    border = "rounded",
                },
            },
            ghost_text = {
                enabled = true,
            },
            menu = {
                border = "rounded",
                draw = {
                    columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
                    treesitter = { "lsp" },
                },
            },
            list = {
                selection = "preselect",
            },
        },

        snippets = {
            expand = function(snippet)
                require("luasnip").lsp_expand(snippet)
            end,
            active = function(filter)
                if filter and filter.direction then
                    return require("luasnip").jumpable(filter.direction)
                end
                return require("luasnip").in_snippet()
            end,
            jump = function(direction)
                require("luasnip").jump(direction)
            end,
        },

        sources = {
            default = { "lsp", "snippets", "buffer", "luasnip", "lazydev" },
            -- Disable cmdline completions
            cmdline = {},
            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    min_keyword_length = 3,
                },
                lsp = {
                    min_keyword_length = 3,
                    max_items = 20,
                    fallbacks = { "lazydev" },
                },
                snippets = {
                    min_keyword_length = 3,
                },
                buffer = {
                    min_keyword_length = 3,
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
