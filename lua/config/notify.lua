local ok, notify = pcall(require, "notify")
if not ok then
    vim.notify("Unable to require notify")
    return
end

notify.setup({})

vim.notify = notify
