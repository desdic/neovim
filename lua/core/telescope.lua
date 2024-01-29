local M = {}

-- Search in my notes
function M.grep_notes()
    local tsbuildin = require("telescope.builtin")
    local optsgrep = {}
    optsgrep.search_dirs = { "~/notes/" }
    optsgrep.prompt_prefix = "   "
    optsgrep.prompt_title = "Search Notes"
    tsbuildin.live_grep(optsgrep)
end

-- Search in my neovim config
function M.search_nvim()
    local tsbuildin = require("telescope.builtin")
    tsbuildin.find_files({ prompt_title = "< VimRC >", cwd = "$HOME/.config/nvim/" })
end

-- Filter for jumping to a line using find_files/git_files
function M.jump_to_line_filter(prompt)
    local action_state = require("telescope.actions.state")
    local find_colon = string.find(prompt, ":")
    if find_colon then
        local ret = string.sub(prompt, 1, find_colon - 1)
        vim.schedule(function()
            local prompt_bufnr = vim.api.nvim_get_current_buf()
            local state = action_state.get_current_picker(prompt_bufnr).previewer.state
            local lnum = tonumber(prompt:sub(find_colon + 1))

            if type(lnum) == "number" then
                if state then
                    local win = tonumber(state.winid)
                    local bufnr = tonumber(state.bufnr)
                    local line_count = vim.api.nvim_buf_line_count(bufnr)
                    vim.api.nvim_win_set_cursor(win, { math.max(1, math.min(lnum, line_count)), 0 })
                end
            end
        end)
        local selection = action_state.get_selected_entry()
        if selection then
            ret = selection[1]
        end
        return { prompt = ret }
    end
end

-- Mapping to jump to line specified with : in find_files/git_files
function M.jump_to_line_mapping()
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    actions.select_default:enhance({
        post = function()
            local prompt = action_state.get_current_line()
            local find_colon = string.find(prompt, ":")
            if find_colon then
                local lnum = tonumber(prompt:sub(find_colon + 1))
                vim.api.nvim_win_set_cursor(0, { lnum, 0 })
            end
        end,
    })
    return true
end

return M
