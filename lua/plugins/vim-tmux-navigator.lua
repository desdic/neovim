vim.defer_fn(function()
    vim.pack.add({
        { src = "https://github.com/christoomey/vim-tmux-navigator" },
    }, { confirm = false })

    vim.g.tmux_navigator_no_mappings = 1
    vim.keymap.set("n", "<c-h>", "<cmd>TmuxNavigateLeft<cr>")
    vim.keymap.set("n", "<c-j>", "<cmd>TmuxNavigateDown<cr>")
    vim.keymap.set("n", "<c-k>", "<cmd>TmuxNavigateUp<cr>")
    vim.keymap.set("n", "<c-l>", "<cmd>TmuxNavigateRight<cr>")
    vim.keymap.set("n", "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>")

    vim.keymap.set("t", "<c-h>", [[<C-\><C-N><cmd>TmuxNavigateLeft<cr>]])
    vim.keymap.set("t", "<c-j>", [[<C-\><C-N><cmd>TmuxNavigateDown<cr>]])
    vim.keymap.set("t", "<c-k>", [[<C-\><C-N><cmd>TmuxNavigateUp<cr>]])
    vim.keymap.set("t", "<c-l>", [[<C-\><C-N><cmd>TmuxNavigateRight<cr>]])
    vim.keymap.set("t", "<c-\\>", [[<C-\><C-N><cmd>TmuxNavigatePrevious<cr>]])
end, 500)
