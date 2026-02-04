return {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
        view_options = {
            show_hidden = true,
        },
    },
    keys = {
        {
            "<leader>ne",
            "<cmd>Oil --float<CR>",
            desc = "Browse files/dirs",
        },
        {
            "<leader>re",
            ":Oil oil-ssh:///<left>",
            desc = "Browse remote files/dirs",
        },
    },
    cmd = { "Oil" },
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
