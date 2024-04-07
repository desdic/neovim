return {
    "chentoast/marks.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
        { "m", "<Plug>(Marks-set)", desc = "Set mark" },
        { "dm", "<Plug>(Marks-delete)", desc = "Delete mark" },
    },
    opts = {
        default_mappings = false,
    },
}
