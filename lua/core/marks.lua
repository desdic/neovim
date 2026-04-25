-- Borrowed from https://github.com/lewis6991/dotfiles/blob/0071d6f1a97f8f6080eb592c4838d92f77901e84/config/nvim/lua/gizmos/marksigns.lua and MariaSolOs

vim.defer_fn(function()
    local ns = vim.api.nvim_create_namespace("marksnamespace")

    --- Decorate a mark in the given buffer using extmark
    ---@param bufnr integer
    ---@param mark table
    local function decorate_mark(bufnr, mark)
        pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, mark.pos[2] - 1, 0, {
            sign_text = mark.mark:sub(2), -- The mark character, skip first char
            sign_hl_group = "DiagnosticSignOk",
        })
    end

    -- Decoration provider callback function
    ---@param _ table request context, unused
    ---@param _ integer winid, unused
    ---@param bufnr integer
    ---@param top_row integer
    ---@param bot_row integer
    local function on_win(_, _, bufnr, top_row, bot_row)
        local filename = vim.api.nvim_buf_get_name(bufnr)
        if filename == "" then
            return
        end

        vim.api.nvim_buf_clear_namespace(bufnr, ns, top_row, bot_row)
        local abs_filename = vim.fn.fnamemodify(filename, ":p:a")

        -- Render global marks
        for _, mark in ipairs(vim.fn.getmarklist()) do
            if mark.mark:match("^.[a-zA-Z]$") then
                local mark_file = mark.file and vim.fn.fnamemodify(mark.file, ":p:a")
                if abs_filename == mark_file then
                    decorate_mark(bufnr, mark)
                end
            end
        end

        -- Render local marks
        for _, mark in ipairs(vim.fn.getmarklist(bufnr)) do
            if mark.mark:match("^.[a-zA-Z]$") then
                decorate_mark(bufnr, mark)
            end
        end
    end

    -- Register the decoration provider
    vim.api.nvim_set_decoration_provider(ns, { on_win = on_win })

    -- Listen for 'm' commands (vim marks) to trigger redraws
    vim.on_key(function(_, typed)
        if typed:sub(1, 1) ~= "m" then
            return
        end
        local mark = typed:sub(2)
        vim.schedule(function()
            if mark:match("[A-Z]") then
                -- Redraw all windows for global marks
                for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                    vim.api.nvim__redraw({ win = win, range = { 0, -1 } })
                end
            else
                -- Redraw current buffer for local marks
                vim.api.nvim__redraw({ range = { 0, -1 } })
            end
        end)
    end, ns)
end, 100)
