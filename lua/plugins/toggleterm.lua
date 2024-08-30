return {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
        { "<c-t>", "<cmd>ToggleTerm<cr>", desc = "Toggle term", mode = { "n", "t" } },
        { "<leader>tts", "<cmd>TermSelect<cr>", desc = "Toggle term select" },
    },
    version = "*",
    opts = {
        size = 20,
    },
}
