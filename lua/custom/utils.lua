local M = {}

function M.toggle_mouse()
    if vim.o.mouse == "" then
        vim.o.mouse = "nvi"
    else
        vim.o.mouse = ""
    end
end

return M
