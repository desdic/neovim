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
                "dashboard",
                "neo-tree",
                "Trouble",
                "trouble",
                "lazy",
                "mason",
                "notify",
                "toggleterm",
                "lazyterm",
            },
        },
    },
    main = "ibl",
    config = function(_, opts)
        require("ibl").setup(opts)
    end,
}
