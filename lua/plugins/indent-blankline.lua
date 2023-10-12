return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "VeryLazy" },
    opts = {
        indent = { char = "│", tab_char = "▸" },
        scope = {
            enabled = false,
        },
        exclude = {
            filetypes = { "help", "alpha", "lazy", "mason", "toggleterm", "lazyterm", "notify", "lazy", "aerial" },
        },
    },
    config = function(_, opts)
        require("ibl").setup(opts)
    end,
}
