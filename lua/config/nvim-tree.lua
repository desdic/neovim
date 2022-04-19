local ok, ntree = pcall(require, "nvim-tree")
if not ok then
    vim.notify("Unable to require nvim-tree", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

ntree.setup({})

local opts = {noremap = true, silent = true}

vim.keymap.set("n", "<Leader>n", ":NvimTreeToggle<CR>", opts)
vim.keymap.set("n", "<Leader>r", ":NvimTreeRefresh<CR>", opts)
