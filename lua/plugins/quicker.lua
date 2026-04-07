vim.pack.add({
    { src = "https://github.com/stevearc/quicker.nvim" },
}, { confirm = false })

vim.defer_fn(function()
    require("quicker").setup({
        borders = {
            vert = "│", -- Thinner separator.
        },
    })

    vim.keymap.set("n", "<leader>xq", function()
        require("quicker").toggle()
    end, { desc = "Toggle quickfix" })
    vim.keymap.set("n", "<leader>xl", function()
        require("quicker").toggle({ loclist = true })
    end, { desc = "Toggle loclist list" })
    vim.keymap.set("n", "<leader>xd", function()
        local quicker = require("quicker")
        if quicker.is_open() then
            quicker.close()
        else
            vim.diagnostic.setqflist()
        end
    end, { desc = "Toggle diagnostics" })
    vim.keymap.set("n", ">", function()
        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
    end, { desc = "Expand context" })
    vim.keymap.set("n", "<", function()
        require("quicker").collapse()
    end, { desc = "Collapse context" })
end, 500)
