local surround_status, surround = pcall(require, "nvim-surround")
if not surround_status then
    vim.notify("Unable to require nvim-surround", vim.lsp.log_levels.ERROR, {title = "Plugin error"})
    return
end

surround.setup({})
