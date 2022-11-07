local ok, notify = pcall(require, "notify")
if not ok then
    vim.notify("Unable to require notify")
    return
end

notify.setup({background_colour = "#000000"})

vim.notify = notify
