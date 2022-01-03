local ok, ntree = pcall(require, "nvim-tree")
if not ok then
    vim.notify("Unable to require nvim-tree", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

ntree.setup({})
