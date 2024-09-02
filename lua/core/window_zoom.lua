local M = {}

local zoomed = false

function M.toggle()
    -- Ignore toggle term
    if vim.o.filetype == "toggleterm" then
        return
    end
    -- Cannot be zoomed if we only have 1 window
    if vim.fn.winnr("$") < 2 then
        zoomed = false
        return
    end
    if zoomed then
        vim.cmd.wincmd("=")
        zoomed = false
    else
        vim.cmd.wincmd("_")
        vim.cmd.wincmd("|")
        zoomed = true
    end
end

return M
