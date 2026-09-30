-- vim.opt.rtp:prepend(vim.fn.expand("~/src/private/axon.nvim"))
vim.pack.add({
    { src = "https://github.com/desdic/axon.nvim", load = false },
}, { confirm = false })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "http",
    callback = function(event)
        if not vim.g.axon_nvim_loaded then
            require("axon").setup({})
            vim.g.axon_nvim_loaded = true
        end

        local opts = { buffer = event.buf, remap = false }

        opts.desc = "Axon run request"
        vim.keymap.set("n", "<leader>As", "<cmd>AxonRun<cr>", opts)

        opts.desc = "Axon run all requests"
        vim.keymap.set("n", "<leader>Aa", "<cmd>AxonRunAll<cr>", opts)

        opts.desc = "Axon pick request"
        vim.keymap.set("n", "<leader>Ap", "<cmd>AxonPick<cr>", opts)

        opts.desc = "Axon toggle headers"
        vim.keymap.set("n", "<leader>At", "<cmd>AxonToggleHeaders<cr>", opts)

        opts.desc = "Axon rerun request"
        vim.keymap.set("n", "<leader>Ar", "<cmd>AxonRerun<cr>", opts)
    end,
})
