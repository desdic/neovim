return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
        local catppuccin = require("catppuccin")
        local palettes = require("catppuccin.palettes")

        local macchiato = palettes.get_palette("macchiato")
        local mocha = palettes.get_palette("mocha")

        catppuccin.setup({
            compile = { enabled = true, path = vim.fn.stdpath("cache") .. "/catppuccin" },
            transparent_background = false,
            term_colors = false,
            integrations = {
                treesitter = true,
                native_lsp = { enabled = true },
                gitsigns = true,
                telescope = true,
                nvimtree = { enabled = true, show_root = false },
                indent_blankline = { enabled = false, colored_indent_levels = false },
                bufferline = true,
                markdown = false,
                ts_rainbow = true,
                navic = { enabled = true, custom_bg = mocha.mantle },
                dap = { enabled = true, enable_ui = true },
                notify = true,
                leap = true,
                mini = true,
                harpoon = true,
                illuminate = true,
                mason = true
            },
            highlight_overrides = {
                macchiato = {
                    NormalFloat = { bg = macchiato.base, style = {} },
                    DiagnosticError = { bg = macchiato.base, style = {} },
                    DiagnosticWarn = { bg = macchiato.base, style = {} },
                    DiagnosticInfo = { bg = macchiato.base, style = {} },
                    DiagnosticHint = { bg = macchiato.base, style = {} }
                }
            }
        })

        vim.g.catppuccin_flavour = "macchiato"
        vim.cmd([[colorscheme catppuccin]])

        vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
    end
}
