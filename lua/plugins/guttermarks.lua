vim.defer_fn(function()
    vim.pack.add({
        { src = "https://github.com/dimtion/guttermarks.nvim" },
    }, { confirm = false })

    require("guttermarks").setup({
        global_mark = { enabled = false },
    })
end, 100)
