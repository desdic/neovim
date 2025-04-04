return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
        indent = { char = "│", tab_char = "▸" },
        scope = {
            enabled = false,
        },
        exclude = {
            filetypes = {
                "help",
                "Trouble",
                "trouble",
                "lazy",
                "mason",
                "notify",
                "lazyterm",
            },
        },
    },
    main = "ibl",
    config = function(_, opts)
        require("ibl").setup(opts)
    end,
}
