local peek_status, peek = pcall(require, "peek")
if not peek_status then
    vim.notify("Unable to require peek", vim.lsp.log_levels.ERROR, {title = "Plugin error"})
    return
end

peek.setup()

vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
