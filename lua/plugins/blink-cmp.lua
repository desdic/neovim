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
            ["<CR>"] = { "select_and_accept", "fallback" },
            ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
            -- ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            -- ["<C-f>"] = { "scroll_documentation_down", "fallback" },
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
                -- auto_show = false,
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

        sources = {
            default = { "lsp", "snippets", "buffer", "lazydev" },
            -- Disable cmdline completions
            cmdline = {},
            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    min_keyword_length = 2,
                },
                lsp = {
                    min_keyword_length = 2,
                    max_items = 20,
                    fallbacks = { "lazydev" },
                },
                snippets = {
                    min_keyword_length = 2,
                },
                buffer = {
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
