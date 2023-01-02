local M = {"rcarriga/nvim-notify", event = "VeryLazy"}

function M.config()
    local notify = require("notify")

    notify.setup({
        background_colour = "#000000",
        timeout = 1000,
        level = vim.log.levels.INFO,
        fps = 20,
        max_height = function() return math.floor(vim.o.lines * 0.75) end,
        max_width = function() return math.floor(vim.o.columns * 0.75) end
    })

    vim.notify = notify
end

return M
