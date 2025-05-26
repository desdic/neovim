return {
    "sindrets/diffview.nvim",
    enabled = false,
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
        { "<leader>dv", "<cmd>DiffviewOpen<CR>", desc = "DiffView" },
    },
}
