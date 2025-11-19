return {
    "saghen/blink.indent",
    opts = {
        blocked = {
            -- default: 'terminal', 'quickfix', 'nofile', 'prompt'
            buftypes = { include_defaults = true },
            -- default: 'lspinfo', 'packer', 'checkhealth', 'help', 'man', 'gitcommit', 'dashboard', ''
            filetypes = { include_defaults = true },
        },
        mappings = {
            -- which lines around the scope are included for 'ai': 'top', 'bottom', 'both', or 'none'
            border = "both",
            -- set to '' to disable
            -- textobjects (e.g. `y2ii` to yank current and outer scope)
            object_scope = "ii",
            object_scope_with_border = "ai",
            -- motions
            goto_top = "[i",
            goto_bottom = "]i",
        },
        static = {
            enabled = true,
            -- char = "│",
            char = "│",
            whitespace_char = nil, -- inherits from `vim.opt.listchars:get().space` when `nil` (see `:h listchars`)
            priority = 1,
            -- specify multiple highlights here for rainbow-style indent guides
            -- highlights = { 'BlinkIndentRed', 'BlinkIndentOrange', 'BlinkIndentYellow', 'BlinkIndentGreen', 'BlinkIndentViolet', 'BlinkIndentCyan' },
            highlights = { "BlinkIndent" },
        },
        scope = {
            enabled = true,
            char = "│ ",
            priority = 1000,
            -- set this to a single highlight, such as 'BlinkIndent' to disable rainbow-style indent guides
            -- highlights = { 'BlinkIndentScope' },
            -- optionally add: 'BlinkIndentRed', 'BlinkIndentCyan', 'BlinkIndentYellow', 'BlinkIndentGreen'
            -- highlights = { "BlinkIndentOrange", "BlinkIndentViolet", "BlinkIndentBlue" },
            highlights = { "BlinkIndentBlue" },
            -- enable to show underlines on the line above the current scope
            underline = {
                enabled = false,
                -- optionally add: 'BlinkIndentRedUnderline', 'BlinkIndentCyanUnderline', 'BlinkIndentYellowUnderline', 'BlinkIndentGreenUnderline'
                highlights = { "BlinkIndentOrangeUnderline", "BlinkIndentVioletUnderline", "BlinkIndentBlueUnderline" },
            },
        },
    },
}
