return {
    "j-hui/fidget.nvim",
    opts = {},
    config = function(_, opts)
        require("fidget").setup(opts)
    end,
}
