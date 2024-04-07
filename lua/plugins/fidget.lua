return {
    "j-hui/fidget.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
    config = function(_, opts)
        require("fidget").setup(opts)
    end,
}
