return {
    "tpope/vim-fugitive",
    event = "BufWinEnter",
    keys = {
        { "<leader>gs", vim.cmd.Git },
        { "<leader>gp", "<cmd>Git pull --rebase<cr>" }, -- rebase always
    },
    config = function()
        local fugitive_augroup = vim.api.nvim_create_augroup("fugitive_augroup", {})
        vim.api.nvim_create_autocmd("BufWinEnter", {
            group = fugitive_augroup,
            pattern = "*",
            callback = function()
                if vim.bo.ft ~= "fugitive" then
                    return
                end

                local bufnr = vim.api.nvim_get_current_buf()
                local opts = { buffer = bufnr, remap = false }
                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git("push")
                end, opts)

                -- NOTE: It allows me to easily set the branch i am pushing and any tracking
                -- needed if i did not set the branch up correctly
                vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts)

                vim.keymap.set("n", "gh", "<cmd>diffget //2<cr>", opts)
                vim.keymap.set("n", "gl", "<cmd>diffget //3<cr>", opts)
            end,
        })
    end,
}
