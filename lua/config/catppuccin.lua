local ok, catppuccin = pcall(require, "catppuccin")
if not ok then
    vim.notify("Unable to require catppuccin", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

-- configure it
catppuccin.setup({
    transparent_background = false,
    term_colors = false,
    styles = {
        comments = "italic",
        functions = "italic",
        keywords = "italic",
        strings = "NONE",
        variables = "NONE"
    },
    integrations = {
        treesitter = true,
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = "italic",
                hints = "italic",
                warnings = "italic",
                information = "italic"
            },
            underlines = {
                errors = "underline",
                hints = "underline",
                warnings = "underline",
                information = "underline"
            }
        },
        lsp_saga = false,
        gitsigns = true,
        telescope = true,
        nvimtree = {enabled = true, show_root = false},
        indent_blankline = {enabled = false, colored_indent_levels = false},
        bufferline = false,
        markdown = false,
        lightspeed = false,
        ts_rainbow = true
    }
})

local colors = require("catppuccin.api.colors").get_colors()
catppuccin.remap({
    NormalFloat = {bg = colors.black2},
    DiagnosticError = {bg = colors.black2}
})

vim.cmd("colorscheme catppuccin")
