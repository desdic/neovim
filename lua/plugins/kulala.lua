vim.pack.add({
    { src = "https://github.com/mistweaverco/kulala.nvim" },
}, { confirm = false })

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "http", "rest" },
    callback = function()
        require("kulala").setup({
            additional_curl_options = { "-n" },
        })

        vim.keymap.set("n", "<leader>Rs", function()
            require("kulala").run()
        end, { desc = "Run request" })
        vim.keymap.set("n", "<leader>Ra", function()
            require("kulala").run_all()
        end, { desc = "Run all request" })
        vim.keymap.set("n", "<leader>Rt", function()
            require("kulala").toggle_view()
        end, { desc = "Toggle view" })
        vim.keymap.set("n", "<leader>Rr", function()
            require("kulala").replay()
        end, { desc = "Replay requests" })
    end,
})
