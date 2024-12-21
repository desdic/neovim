return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
        local catppuccin = require("catppuccin")
        local palettes = require("catppuccin.palettes")
        local mocha = palettes.get_palette("mocha")

        catppuccin.setup({
            flavour = "mocha",
            compile = { enabled = true, path = vim.fn.stdpath("cache") .. "/catppuccin" },
            transparent_background = false,
            term_colors = false,
            integrations = {
                bufferline = true,
                dap = true,
                dap_ui = true,
                fzf = true,
                gitsigns = true,
                indent_blankline = {
                    enabled = true,
                },
                blink_cmp = true,
                markdown = false,
                mason = true,
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
                rainbow_delimiters = true,
                semantic_tokens = true,
                treesitter = true,
                which_key = true,
            },
            highlight_overrides = {
                mocha = {
                    DiagnosticVirtualTextError = { bg = mocha.base, style = {} },
                    DiagnosticVirtualTextWarn = { bg = mocha.base, style = {} },
                    DiagnosticVirtualTextInfo = { bg = mocha.base, style = {} },
                    DiagnosticVirtualTextHint = { bg = mocha.base, style = {} },
                    DiagnosticFloatingError = { bg = mocha.base, style = {} },
                    DiagnosticFloatingWarn = { bg = mocha.base, style = {} },
                    DiagnosticFloatingInfo = { bg = mocha.base, style = {} },
                    DiagnosticFloatingHint = { bg = mocha.base, style = {} },
                    WinSeparator = { fg = mocha.mauve },
                },
            },
        })

        vim.cmd([[colorscheme catppuccin]])

        vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
        vim.api.nvim_set_hl(0, "LspInlayHint", { link = "Comment" })
    end,
}
