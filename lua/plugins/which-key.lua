vim.pack.add({
    { src = "https://github.com/folke/which-key.nvim" },
}, { confirm = false })

vim.defer_fn(function()
    require("which-key").setup({
        plugins = {
            marks = false,
            registers = false,
        },
        delay = 1000,
    })

    vim.keymap.set("n", "<leader>?", function()
        require("which-key").show({ global = false })
    end, { desc = "Buffer Local Keymaps (which-key)" })
end, 500)
