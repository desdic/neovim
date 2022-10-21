local status_ok, impatient = pcall(require, "impatient")
if not status_ok then
    vim.notify("Unable to require impatient", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

impatient.enable_profile()
