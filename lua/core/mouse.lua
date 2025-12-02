local M = {}

function M.toggle()
    if vim.o.mouse == "" then
        vim.o.mouse = "a"
    else
        vim.o.mouse = ""
    end
end

return M
