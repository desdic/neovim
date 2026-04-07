vim.pack.add({
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
}, { confirm = false })

vim.defer_fn(function()
    require("nvim-web-devicons").setup({})
end, 100)
