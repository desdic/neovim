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
            compile = {enabled = true, path = vim.fn.stdpath("cache") .. "/catppuccin"},
            transparent_background = false,
            term_colors = false,
            integrations = {
                cmp = true,
                treesitter = true,
                native_lsp = {enabled = true},
                gitsigns = true,
                telescope = true,
                nvimtree = {enabled = true, show_root = false},
                bufferline = true,
                markdown = false,
                ts_rainbow2 = true,
                navic = {enabled = true, custom_bg = mocha.mantle},
                dap = {enabled = true, enable_ui = true},
                notify = true,
                leap = true,
                mini = true,
                harpoon = true,
                illuminate = true,
                mason = true
            },
            highlight_overrides = {
                mocha = {
                    DiagnosticVirtualTextError = {bg = mocha.base, style = {}},
                    DiagnosticVirtualTextWarn = {bg = mocha.base, style = {}},
                    DiagnosticVirtualTextInfo = {bg = mocha.base, style = {}},
                    DiagnosticVirtualTextHint = {bg = mocha.base, style = {}},
                    DiagnosticFloatingError = {bg = mocha.base, style = {}},
                    DiagnosticFloatingWarn = {bg = mocha.base, style = {}},
                    DiagnosticFloatingInfo = {bg = mocha.base, style = {}},
                    DiagnosticFloatingHint = {bg = mocha.base, style = {}}
                }
            }
        })

        -- vim.g.catppuccin_flavour = "macchiato"
        vim.cmd([[colorscheme catppuccin]])

        vim.api.nvim_set_hl(0, "LeapBackdrop", {link = "Comment"})
    end
}
