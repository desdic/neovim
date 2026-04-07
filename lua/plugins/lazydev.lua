vim.pack.add({
    { src = "https://github.com/folke/lazydev.nvim" },
}, { confirm = false })

vim.defer_fn(function()
    require("lazydev").setup({
        library = { "nvim-dap-ui" },
    })
end, 500)
