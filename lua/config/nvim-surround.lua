local ok, surround = pcall(require, "nvim-surround")
if not ok then
    vim.notify("Unable to require nvim-surround", vim.lsp.log_levels.ERROR,
			   {title = "Plugin error"})
    return
end

surround.setup()
