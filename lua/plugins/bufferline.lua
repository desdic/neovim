local ok, bufferline = pcall(require, "bufferline")
if not ok then
    vim.notify("Unable to require bufferline", vim.lsp.log_levels.ERROR, {title = "Plugin error"})
    return
end

bufferline.setup({
    options = {
        show_buffer_close_icons = false,
        show_buffer_icons = false,
        show_close_icon = false,
        persist_buffer_sort = true,
        name_formatter = function(opts) return string.format(" %s ", opts.name) end,
        numbers = function(opts) return string.format(" %s ", opts.ordinal) end
    }
})

vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", {silent = true, noremap = true, desc = "Move to next buffer"})

vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>",
               {silent = true, noremap = true, desc = "Move to previous buffer"})
