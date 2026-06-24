vim.pack.add({
    { src = "https://github.com/mistweaverco/kulala.nvim", load = false },
}, { confirm = false })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "http",
    callback = function(event)
        if not vim.g.kulala_nvim_loaded then
            vim.cmd("packadd kulala.nvim")

            require("kulala").setup({})
            vim.g.kulala_nvim_loaded = true
        end

        local opts = { buffer = event.buf, remap = false }

        opts.desc = "Run request"
        vim.keymap.set("n", "<leader>Rs", function()
            require("kulala").run()
        end, opts)

        opts.desc = "Run all requests"
        vim.keymap.set("n", "<leader>Ra", function()
            require("kulala").run_all()
        end, opts)

        opts.desc = "Toggle view"
        vim.keymap.set("n", "<leader>Rt", function()
            require("kulala").toggle_view()
        end, opts)

        opts.desc = "Replay requests"
        vim.keymap.set("n", "<leader>Rr", function()
            require("kulala").replay()
        end, opts)
    end,
})
