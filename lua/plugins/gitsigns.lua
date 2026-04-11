vim.pack.add({
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
}, { confirm = false })

vim.defer_fn(function()
    require("gitsigns").setup({})
end, 100)
