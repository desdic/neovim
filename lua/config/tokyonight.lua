local ok, _ = pcall(require, "tokyonight")
if not ok then
    vim.notify("Unable to require tokyonight", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

vim.g.tokyonight_style = "night"
vim.cmd[[colorscheme tokyonight]]
