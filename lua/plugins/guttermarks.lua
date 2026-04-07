vim.pack.add({
    { src = "https://github.com/dimtion/guttermarks.nvim" },
}, { confirm = false })

vim.defer_fn(function()
    require("guttermarks").setup({
        global_mark = { enabled = false },
    })
end, 100)
