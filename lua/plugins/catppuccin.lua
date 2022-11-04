local ok, catppuccin = pcall(require, "catppuccin")
if not ok then
    vim.notify("Unable to require catppuccin", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

local pok, palettes = pcall(require, "catppuccin.palettes")
if not pok then
    vim.notify("Unable to require catppuccin.palettes",
               vim.lsp.log_levels.ERROR, {title = "Plugin error"})
    return
end

local macchiato = palettes.get_palette("macchiato")
local mocha = palettes.get_palette("mocha")

catppuccin.setup({
    compile = {enabled = true, path = vim.fn.stdpath("cache") .. "/catppuccin"},
    transparent_background = false,
    term_colors = false,
    integrations = {
        treesitter = true,
        native_lsp = {enabled = true},
        gitsigns = true,
        telescope = true,
        nvimtree = {enabled = true, show_root = false},
        indent_blankline = {enabled = false, colored_indent_levels = false},
        bufferline = true,
        markdown = false,
        ts_rainbow = true,
        -- navic = {enabled = true, custom_bg = "#181825"},
        navic = {enabled = true, custom_bg = mocha.mantle},
        dap = {enabled = true, enable_ui = true},
        notify = true,
        hop = true
    },
    highlight_overrides = {
        macchiato = {
            NormalFloat = {bg = macchiato.base, style = {}},
            DiagnosticError = {bg = macchiato.base, style = {}},
            DiagnosticWarn = {bg = macchiato.base, style = {}},
            DiagnosticInfo = {bg = macchiato.base, style = {}},
            DiagnosticHint = {bg = macchiato.base, style = {}}
        }
    }
})

vim.g.catppuccin_flavour = "macchiato"
vim.cmd([[colorscheme catppuccin]])

-- vim.cmd[[hi NormalFloat guibg=Base]]
-- vim.cmd[[hi DiagnosticError guibg=Base]]
-- vim.cmd[[hi DiagnosticWarn guibg=Base]]
-- vim.cmd[[hi DiagnosticInfo guibg=Base]]
-- vim.cmd[[hi DiagnosticHint guibg=Base]]
