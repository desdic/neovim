return {
    "tpope/vim-fugitive",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "Git" },
    keys = {
        { "<leader>gs", vim.cmd.Git, desc = "Git" },
        { "<leader>gv", "<cmd>Gvdiffsplit!<cr>", desc = "Git diff split" },
        { "gh", "<cmd>diffget //2<cr>", desc = "Git conflict choose left" },
        { "gl", "<cmd>diffget //3<cr>", desc = "Git conflict choose right" },
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
                local opts = { buffer = bufnr, remap = false, desc = "Git push" }
                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git("push")
                end, opts)

                vim.keymap.set(
                    "n",
                    "<leader>gp",
                    "<cmd>Git spull<cr>",
                    { buffer = bufnr, remap = false, desc = "Git stash/pull rebase" }
                )
            end,
        })
    end,
}
