return {
    "akinsho/nvim-bufferline.lua",
    event = "VeryLazy",
    keys = {
        {"<S-l>", ":BufferLineCycleNext<CR>", desc = "Move to next buffer"},
        {"<S-h>", ":BufferLineCyclePrev<CR>", desc = "Move to previous buffer"}
    },
    opts = {
        options = {
            show_buffer_close_icons = false,
            show_buffer_icons = false,
            show_close_icon = false,
            persist_buffer_sort = true,
            name_formatter = function(opts) return string.format(" %s ", opts.name) end,
            numbers = function(opts) return string.format(" %s ", opts.ordinal) end
        }
    }
}
