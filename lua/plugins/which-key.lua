return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 800
    end,
    opts = {
        plugins = {
            marks = false,
            registers = false,
        },
    },
}
