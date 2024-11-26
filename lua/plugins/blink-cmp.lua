return {
    "saghen/blink.cmp",
    event = { "LspAttach" },

    -- enabled = false,
    -- lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    -- dependencies = "rafamadriz/friendly-snippets",
    dependencies = { "rafamadriz/friendly-snippets" },

    -- use a release tag to download pre-built binaries
    version = "v0.*",

    opts = {
        keymap = {
            preset = "default",
            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-j>"] = { "select_next", "fallback" },
            -- ["<C-p>"] = { "select_prev", "fallback" },
            -- ["<C-n"] = { "select_next", "fallback" },
            ["<Tab>"] = {
                function(cmp)
                    if cmp.is_in_snippet() then
                        return cmp.snippet_forward()
                    else
                        return cmp.select_next()
                    end
                end,
                "fallback",
            },
            ["<S-Tab>"] = {
                function(cmp)
                    if cmp.is_in_snippet() then
                        return cmp.snippet_backward()
                    else
                        return cmp.select_prev()
                    end
                end,
                "fallback",
            },
            ["<CR>"] = { "select_and_accept", "fallback" },
            -- ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            -- ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        },
        highlight = {
            -- sets the fallback highlight groups to nvim-cmp's highlight groups
            -- useful for when your theme doesn't support blink.cmp
            -- will be removed in a future release, assuming themes add support
            use_nvim_cmp_as_default = false,
        },
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",

        -- default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, via `opts_extend`
        sources = {
            completion = {
                enabled_providers = { "lsp", "path", "snippets", "buffer" },
            },
            providers = {
                lsp = {
                    min_keyword_length = 2,
                    max_items = 20,
                },
                path = { min_keyword_length = 2 },
                snippets = { min_keyword_length = 2 },
            },
        },

        -- experimental auto-brackets support
        accept = {
            auto_brackets = { enabled = true },
        },

        windows = {
            autocomplete = {
                border = "rounded",
                selection = "preselect",
                draw = {
                    columns = { { "label", "label_description", gap = 1 }, { "kind_icon", gap = 1, "kind" } },
                },
            },
            documentation = {
                border = "rounded",
                auto_show = true,
            },
        },
        trigger = { signature_help = { enabled = true } },
    },
    opts_extend = { "sources.completion.enabled_providers" },
}
