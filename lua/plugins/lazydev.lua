vim.defer_fn(function()
    vim.pack.add({
        { src = "https://github.com/folke/lazydev.nvim" },
    }, { confirm = false })

    require("lazydev").setup({
        library = { "nvim-dap-ui" },
    })
end, 500)
