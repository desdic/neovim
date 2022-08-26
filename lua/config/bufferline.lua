local ok, bufferline = pcall(require, "bufferline")
if not ok then
    vim.notify("Unable to require bufferline", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

bufferline.setup({
    options = {
        show_buffer_close_icons = false,
        show_close_icon = false,
		persist_buffer_sort = true,
        name_formatter = function(opts)
            return string.format(" %s ", opts.name)
        end,
        numbers = function(opts)
            return string.format(" %s ", opts.ordinal)
        end,
    }
})

for i = 1, 9 do
vim.keymap.set("n", "<Leader>" .. i,
               function() bufferline.go_to_buffer(i, true) end,
               {noremap = true, silent = true, desc = "Find files"})
end
