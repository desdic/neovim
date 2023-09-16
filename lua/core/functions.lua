vim.api.nvim_create_user_command("UpdateAll", function()
    vim.cmd([[Lazy sync]])
    vim.cmd([[TSUpdateSync]])
    vim.cmd([[MasonUpdate]]) -- Only updates the registry not the packages
end, {})
