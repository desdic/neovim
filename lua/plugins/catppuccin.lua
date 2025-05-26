return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
        local catppuccin = require("catppuccin")

        catppuccin.setup({
            flavour = "mocha",
            default_integrations = false,
            dim_inactive = { enabled = true },
            integrations = {
                dap = true,
                dap_ui = true,
                render_markdown = true,
                gitsigns = true,
                indent_blankline = {
                    enabled = true,
                },
                blink_cmp = true,
                markdown = false,
                mini = {
                    enabled = true,
                },
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                        ok = { "italic" },
                    },
                    underlines = {
                        errors = { "underline" },
                        hints = { "underline" },
                        warnings = { "underline" },
                        information = { "underline" },
                        ok = { "underline" },
                    },
                    inlay_hints = {
                        background = true,
                    },
                },
                semantic_tokens = true,
                snacks = true,
                treesitter = true,
                which_key = true,
            },
            custom_highlights = function(colors)
                return {
                    MiniTablineCurrent = {
                        fg = colors.text,
                        bg = colors.surface0,
                        style = { "bold" },
                    },
                    MiniTablineModifiedCurrent = {
                        fg = colors.text,
                        bg = colors.surface0,
                        style = { "bold" },
                    },
                    MiniTablineModifiedVisible = {
                        fg = colors.text,
                        style = {},
                    },
                    NormalFloat = { bg = colors.base, fg = colors.text }, -- https://github.com/catppuccin/nvim/issues/823
                    SnacksIndent1 = { fg = "#ababab" },
                    SnacksIndent2 = { fg = "#9d9d9d" },
                    SnacksIndent3 = { fg = "#8f8f8f" },
                    SnacksIndent4 = { fg = "#818181" },
                    SnacksIndent5 = { fg = "#737373" },
                    SnacksIndent6 = { fg = "#656565" },
                    SnacksIndent7 = { fg = "#575757" },
                    SnacksIndent8 = { fg = "#4a4a4a" },
                }
            end,
        })

        vim.cmd([[colorscheme catppuccin]])
    end,
}
