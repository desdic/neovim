vim.g.debchangelog_complete_mode = "local"
-- This tells the plugin not to use apt-listbugs for bug completions
vim.g.debchangelog_capabilities = "none"
vim.opt_local.autocomplete = false

-- If debchangelog contains previous errors I don't want an error on every letter I type
vim.api.nvim_create_autocmd("FileType", {
    pattern = "debchangelog",
    callback = function()
        -- Wipe out the omnifunc so plugins don't try to auto-trigger it
        vim.bo.omnifunc = ""
    end,
})
