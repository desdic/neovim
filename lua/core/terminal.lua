local M = {}

local state = {
    current = {
        buf = -1,
        win = -1,
    },
}

local function create_vertical_window(opts)
    opts = opts or {}
    -- Get the current window's dimensions
    local total_lines = vim.o.lines
    local total_cols = vim.o.columns

    -- Calculate the width for the new vertical split (20% of the screen width)
    local width = math.floor(total_cols * 0.2)

    -- Create a new buffer
    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
    end

    -- Get the current window's dimensions
    local current_win = vim.api.nvim_get_current_win()
    local win_width = vim.api.nvim_win_get_width(current_win)

    -- Resize the current window to make space for the new split
    vim.api.nvim_win_set_width(current_win, win_width - width)

    -- Create a new window for the buffer
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = total_lines,
        row = 0,
        col = total_cols - width,
        style = "minimal",
        border = "none",
    })

    -- Move it to the bottom
    vim.cmd.wincmd("J")

    return { buf = buf, win = win }
end

M.toggle = function()
    if not vim.api.nvim_win_is_valid(state.current.win) then
        state.current = create_vertical_window({ buf = state.current.buf })
        if vim.bo[state.current.buf].buftype ~= "terminal" then
            vim.cmd.term()
        end
    else
        vim.api.nvim_win_hide(state.current.win)
    end
end

return M
