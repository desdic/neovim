local M = {}

-- Check if plugin is loaded
M.has_plugin = function(plugin)
    return pcall(require, plugin)
end

M.is_top_empty_file = function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local _, col = vim.api.nvim_win_get_cursor(0)
    if #lines <= 1 and col == 2 then
        return true
    end
    return false
end

return M
