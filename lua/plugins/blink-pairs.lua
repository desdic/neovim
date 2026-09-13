vim.pack.add({
    "https://github.com/saghen/blink.lib",
    { src = "https://github.com/saghen/blink.pairs", version = vim.version.range("*") },
})

require("blink.pairs").download():pwait(60000)
require("blink.pairs").setup({
    mappings = {
        cmdline = false,
        pairs = {
            ["`"] = {
                {
                    "```",
                    when = function(ctx)
                        return ctx:text_before_cursor(2) == "``"
                    end,
                    languages = { "markdown", "markdown_inline", "typst", "vimwiki", "rmarkdown", "rmd", "quarto" },
                },
                { "`", "'", languages = { "bibtex", "latex", "plaintex" } },
                {
                    "`",
                    enter = false,
                    space = false,
                    when = function(ctx)
                        return not ctx.ts:is_language({ "markdown", "markdown_inline" })
                    end,
                },
            },
        },
    },
    highlights = {
        enabled = true,
        -- requires require('vim._core.ui2').enable({}), otherwise has no effect
        cmdline = false,
        groups = {
            "BlinkPairsOrange",
            "BlinkPairsPurple",
            "BlinkPairsBlue",
        },
        unmatched_group = "BlinkPairsUnmatched",

        matchparen = {
            enabled = true,
            cmdline = false,
            include_surrounding = false,
            group = "BlinkPairsMatchParen",
            priority = 250,
        },
    },
})
