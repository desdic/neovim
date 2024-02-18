return {
    "folke/which-key.nvim",
    enabled = false,
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 500
    end,
    opts = {
        plugins = {
            marks = false,
            registers = false
        }
    },
}
