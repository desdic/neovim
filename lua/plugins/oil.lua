vim.pack.add({ { src = "https://github.com/stevearc/oil.nvim" } }, { confirm = false })

vim.defer_fn(function()
    require("oil").setup({
        default_file_explorer = false, -- we need netrw to download spellings
        view_options = {
            show_hidden = true,
        },
    })

    vim.keymap.set("n", "<leader>ne", ":Oil<CR>", { desc = "Oil" })
end, 500)
