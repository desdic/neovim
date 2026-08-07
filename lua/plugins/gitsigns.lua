vim.defer_fn(function()
    vim.pack.add({
        { src = "https://github.com/lewis6991/gitsigns.nvim" },
    }, { confirm = false })

    require("gitsigns").setup({})
end, 100)
