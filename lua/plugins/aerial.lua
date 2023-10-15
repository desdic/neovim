return {
    "stevearc/aerial.nvim",
    event = { "VeryLazy" },
    opts = {},
    keys = {
        { "<Leader>a", "<cmd>AerialToggle!<CR>" },
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
}
