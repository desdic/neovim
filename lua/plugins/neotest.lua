return {
    "nvim-neotest/neotest",
    keys = {
        {
            "<Leader>rr",
            function()
                require("neotest").run.run()
            end,
            desc = "[R]run test",
        },
        {
            "<Leader>ra",
            function()
                require("neotest").run.run(vim.fn.expand("%"))
            end,
            desc = "[R]run [a]ll tests",
        },
    },
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "alfaix/neotest-gtest",
        "nvim-neotest/neotest-go",
        "nvim-neotest/neotest-python",
    },
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-go"),
                require("neotest-gtest").setup({}),
                require("neotest-python"),
            },
        })
    end,
}
