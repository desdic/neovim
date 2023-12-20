return {
    "xvzc/chezmoi.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("chezmoi").setup({
            edit = {
                watch = true,
            },
        })
    end,
}
