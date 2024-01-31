return {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    keys = {
        { "m", "<Plug>(Marks-set)", desc = "Set mark" },
        { "dm", "<Plug>(Marks-delete)", desc = "Delete mark" },
    },
    opts = {
        default_mappings = false,
    },
}
