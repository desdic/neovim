return {
    "christoomey/vim-tmux-navigator",
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
        "TmuxNavigatorProcessList",
    },
    keys = {
        { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", mode = "n" },
        { "<c-j>", "<cmd>TmuxNavigateDown<cr>", mode = "n" },
        { "<c-k>", "<cmd>TmuxNavigateUp<cr>", mode = "n" },
        { "<c-l>", "<cmd>TmuxNavigateRight<cr>", mode = "n" },
        { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>", mode = "n" },
    },
    init = function()
        vim.g.tmux_navigator_no_mappings = 1
    end,
}
