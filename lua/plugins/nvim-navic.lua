return {
    "SmiteshP/nvim-navic",
    opts = {
        highlight = true,
        depth_limit = 5,
    },
    config = function(_, opts)
        require("nvim-navic").setup(opts)
    end,
}
