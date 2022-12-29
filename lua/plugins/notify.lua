local ok, notify = pcall(require, "notify")
if not ok then
    vim.notify("Unable to require notify")
    return
end

notify.setup({
    background_colour = "#000000",
    timeout = 1000,
    level = vim.log.levels.INFO,
    fps = 20,
    max_height = function() return math.floor(vim.o.lines * 0.75) end,
    max_width = function() return math.floor(vim.o.columns * 0.75) end
})

vim.notify = notify
