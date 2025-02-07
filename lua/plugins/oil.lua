return {
    "stevearc/oil.nvim",
    opts = {
        view_options = {
            show_hidden = true,
        },
    },
    keys = {
        {
            "<leader>ne",
            "<cmd>Oil<CR>",
            desc = "Browse files/dirs",
        },
        {
            "<leader>re",
            ":Oil oil-ssh://",
            desc = "Browse remote files/dirs",
        },
    },
    cmd = { "Oil" },
    -- Optional dependencies
    -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
