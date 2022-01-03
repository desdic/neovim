local ok, comment = pcall(require, "Comment")
if not ok then
    vim.notify("Unable to require Comment", "error")
    return
end

comment.setup()
