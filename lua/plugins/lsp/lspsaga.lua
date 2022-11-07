local saga_status, saga = pcall(require, "lspsaga")
if not saga_status then
    vim.notify("Unable to require lspsaga", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

saga.init_lsp_saga({
    -- keybinds for navigation in lspsaga window
    move_in_saga = {prev = "<C-k>", next = "<C-j>"},
    -- use enter to open file with finder
    finder_action_keys = {open = "<CR>"},
    -- use enter to open file with definition preview
    definition_action_keys = {edit = "<CR>"},
    -- disable virtual text
    code_action_lightbulb = {virtual_text = false}
})
