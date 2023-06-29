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
                cmp = true,
                dap = { enabled = true, enable_ui = true },
                gitsigns = true,
                illuminate = true,
                leap = false,
                lsp_trouble = true,
                markdown = false,
                mason = true,
                mini = true,
                native_lsp = { enabled = true },
                navic = { enabled = true, custom_bg = mocha.mantle },
                notify = true,
                nvimtree = { enabled = true, show_root = false },
                semantic_tokens = true,
                telescope = true,
                treesitter = true,
                ts_rainbow2 = true,
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
                },
            },
        })

        -- vim.g.catppuccin_flavour = "macchiato"
        vim.cmd([[colorscheme catppuccin]])

        vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
        vim.api.nvim_set_hl(0, "LspInlayHint", { link = "Comment" })
    end,
}
