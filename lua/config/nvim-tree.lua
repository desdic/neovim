local ok, ntree = pcall(require, "nvim-tree")
if not ok then
    vim.notify("Unable to require nvim-tree", "error")
    return
end

ntree.setup({})
