return {
    "stevearc/aerial.nvim",
    event = { "VeryLazy" },
    opts = {},
    keys = {
        { "<Leader>xa", "<cmd>AerialToggle!<CR>", desc ="Toggle aerial" },
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
}
