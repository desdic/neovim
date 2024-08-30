return {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
        { "<c-t>", "<cmd>ToggleTerm<cr>", desc = "Toggle term", mode = { "n", "t" } },
        { "<leader>tts", "<cmd>TermSelect<cr>", desc = "Toggle term select" },
    },
    version = "*",
    opts = {},
    config = function(_, opts)
        require("toggleterm").setup(opts)

        ---@diagnostic disable-next-line: duplicate-set-field
        function _G.set_terminal_keymaps()
            vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { noremap = true, buffer = 0, desc = "Esc in terminal" })
            vim.keymap.set("t", "jk", [[<C-\><C-n>]], { noremap = true, buffer = 0, desc = "Esc in terminal" })
            vim.keymap.set(
                "t",
                "<C-h>",
                [[<C-\><C-n><C-W>h]],
                { noremap = true, buffer = 0, desc = "Navigate to left window" }
            )
            vim.keymap.set(
                "t",
                "<C-j>",
                [[<C-\><C-n><C-W>j]],
                { noremap = true, buffer = 0, desc = "Navigate to window below" }
            )
            vim.keymap.set(
                "t",
                "<C-k>",
                [[<C-\><C-n><C-W>k]],
                { noremap = true, buffer = 0, desc = "Navigate to window above" }
            )
            vim.keymap.set(
                "t",
                "<C-l>",
                [[<C-\><C-n><C-W>l]],
                { noremap = true, buffer = 0, desc = "Navigate to right window" }
            )
        end

        vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
    end,
}
