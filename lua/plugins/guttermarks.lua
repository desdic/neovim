return {
    "dimtion/guttermarks.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        global_mark = { enabled = false },
    },
    init = function()
        vim.api.nvim_set_hl(0, "GutterMarksLocal", { fg = "#8ccfcb" })
    end,
}
