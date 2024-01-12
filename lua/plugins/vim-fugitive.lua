return {
    "tpope/vim-fugitive",
    event = "BufWinEnter",
    keys = {
        { "<leader>gs", vim.cmd.Git, desc="Git" },
        { "<leader>gp", "<cmd>Git pull --rebase<cr>", desc = "Git pull rebase" }, -- rebase always
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
                local opts = { buffer = bufnr, remap = false, desc="Git push" }
                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git("push")
                end, opts)

                -- NOTE: It allows me to easily set the branch i am pushing and any tracking
                -- needed if i did not set the branch up correctly
                vim.keymap.set("n", "<leader>t", ":Git push -u origin ", { buffer = bufnr, remap = false, desc="Git push origin" })
                vim.keymap.set("n", "gh", "<cmd>diffget //2<cr>", { buffer = bufnr, remap = false, desc="Git choose left" })
                vim.keymap.set("n", "gl", "<cmd>diffget //3<cr>", { buffer = bufnr, remap = false, desc="Git choose right" })
            end,
        })
    end,
}
