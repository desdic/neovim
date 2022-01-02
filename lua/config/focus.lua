local ok, focus = pcall(require, "focus")
if not ok then
    vim.notify("Unable to require focus")
    return
end

focus.setup({
    enable = true,
    cursorline = true,
    signcolumn = true,
    number = false,
    hybridnumber = true,
    absolutenumber_unfocussed = true,
    excluded_filetypes = {"toggleterm"}
    -- excluded_buftypes = {'help', 'popup'}
})
