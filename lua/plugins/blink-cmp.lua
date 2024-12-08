return {
    "saghen/blink.cmp",
    event = { "LspAttach" },

    dependencies = { "rafamadriz/friendly-snippets", "folke/lazydev.nvim" },

    -- use a release tag to download pre-built binaries
    version = "v0.*",

    opts = {
        keymap = {
            preset = "default",
            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-j>"] = { "select_next", "fallback" },
            ["<Tab>"] = {
                function(cmp)
                    if cmp.snippet_active() then
                        return cmp.snippet_forward()
                    else
                        return cmp.select_next()
                    end
                end,
                "fallback",
            },
            ["<S-Tab>"] = {
                function(cmp)
                    if cmp.snippet_active() then
                        return cmp.snippet_backward()
                    else
                        return cmp.select_prev()
                    end
                end,
                "fallback",
            },
            ["<CR>"] = { "accept", "fallback" },
            -- ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            -- ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        },

        -- don't use in gitcommits
        -- blocked_filetypes = { "gitcommit" },

        completion = {
            accept = {
                auto_brackets = { enabled = true },
            },
            documentation = {
                -- Snippets does not show their content without auto_show
                auto_show = true,
                window = {
                    border = "rounded",
                },
            },
            menu = {
                border = "rounded",
                treesitter = true,
                draw = {
                    columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
                },
            },
            list = {
                selection = "manual",
            },
        },

        sources = {
            completion = {
                enabled_providers = { "lsp", "snippets", "buffer", "lazydev" },
            },
            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    min_keyword_length = 2,
                },
                lsp = {
                    min_keyword_length = 2,
                    max_items = 20,
                    fallback_for = { "lazydev" },
                },
                snippets = {
                    min_keyword_length = 2,
                },
                buffer = {
                    min_keyword_length = 2,
                },
            },
        },

        appearance = {
            -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = "mono",
        },
    },
    opts_extend = { "sources.completion.enabled_providers" },
}
