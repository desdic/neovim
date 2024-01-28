local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set("n", "<leader>ca", function()
    vim.cmd("GoCodeAction")
end, { silent = true, buffer = bufnr, desc = "GoCodeAction" })
