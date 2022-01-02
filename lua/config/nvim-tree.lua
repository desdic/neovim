local ok, ntree = pcall(require, "nvim-tree")
if not ok then
    vim.notify("Unable to require nvim-tree")
    return
end

ntree.setup({})
