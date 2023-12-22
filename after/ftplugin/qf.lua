vim.keymap.set("n", "r", function()
    return ":cdo s///gc<Left><Left><Left><Left>"
end, { silent = false, expr = true, noremap = true, desc = "Rename all in quickfix list" })
