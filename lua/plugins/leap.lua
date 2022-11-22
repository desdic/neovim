local leapok, leap = pcall(require, "leap")
if not leapok then
    vim.notify("Unable to require leap", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

local function leap_multi_win()
    leap.leap({
        target_windows = vim.tbl_filter(function(win)
            return vim.api.nvim_win_get_config(win).focusable
        end, vim.api.nvim_tabpage_list_wins(0))
    })

    -- vim.schedule(function() vim.cmd([[norm zzzv]]) end)
end

vim.keymap.set("n", "s", function() leap_multi_win() end, {})

vim.keymap.set("n", "vo", function()
    leap_multi_win()
    vim.schedule(function() vim.cmd([[norm o]]) end)
    vim.schedule(function() vim.cmd([[startinsert]]) end)
end, {desc = "Jump to line and go into insert mode"})
