local leapok, leap = pcall(require, "leap")
if not leapok then
    vim.notify("Unable to require leap", vim.lsp.log_levels.ERROR, {title = "Plugin error"})
    return
end

leap.add_default_mappings()
-- leap.opts.safe_labels = {}

local function leap_multi_win()
    leap.leap({
        target_windows = vim.tbl_filter(function(win) return vim.api.nvim_win_get_config(win).focusable end,
                                        vim.api.nvim_tabpage_list_wins(0))
    })

    -- vim.schedule(function() vim.cmd([[norm zzzv]]) end)
end

vim.keymap.set("n", "s", function() leap_multi_win() end, {desc = "[S]earch"})

local function get_line_starts(winid)
    local wininfo = vim.fn.getwininfo(winid)[1]
    local cur_line = vim.fn.line(".")

    -- Get targets.
    local targets = {}
    local lnum = wininfo.topline
    while lnum <= wininfo.botline do
        local fold_end = vim.fn.foldclosedend(lnum)
        -- Skip folded ranges.
        if fold_end ~= -1 then
            lnum = fold_end + 1
        else
            if lnum ~= cur_line then table.insert(targets, {pos = {lnum, 1}}) end
            lnum = lnum + 1
        end
    end
    -- Sort them by vertical screen distance from cursor.
    local cur_screen_row = vim.fn.screenpos(winid, cur_line, 1)["row"]
    local function screen_rows_from_cur(t)
        local t_screen_row = vim.fn.screenpos(winid, t.pos[1], t.pos[2])["row"]
        return math.abs(cur_screen_row - t_screen_row)
    end

    table.sort(targets, function(t1, t2) return screen_rows_from_cur(t1) < screen_rows_from_cur(t2) end)

    if #targets >= 1 then return targets end
end

local function leap_to_line()
    local winid = vim.api.nvim_get_current_win()
    leap.leap({target_windows = {winid}, targets = get_line_starts(winid)})
    vim.schedule(function() vim.cmd([[norm o]]) end)
    vim.schedule(function() vim.cmd([[startinsert]]) end)
end

vim.keymap.set("n", "vo", function() leap_to_line() end, {desc = "Jump to line and go into insert mode"})
