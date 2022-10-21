local ok, comment = pcall(require, "Comment")
if not ok then
    vim.notify("Unable to require Comment", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

comment.setup()
