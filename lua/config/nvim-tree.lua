local ok, ntree = pcall(require, "nvim-tree")
if not ok then
    vim.notify("Unable to require nvim-tree", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

ntree.setup({})

local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

keymap("n", "<Leader>n", ":NvimTreeToggle<CR>", opts)
keymap("n", "<Leader>r", ":NvimTreeRefresh<CR>", opts)
