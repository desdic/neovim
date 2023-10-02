return {
    "akinsho/nvim-bufferline.lua",
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
    event = "VeryLazy",
    keys = {
        { "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Move to next buffer" },
        { "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Move to previous buffer" },
    },
    config = function(_, _)
        local mocha = require("catppuccin.palettes").get_palette("mocha")
        require("bufferline").setup({
            options = {
                show_buffer_close_icons = false,
                show_close_icon = false,
                persist_buffer_sort = true,
            },
            highlights = require("catppuccin.groups.integrations.bufferline").get({
                custom = {
                    all = {
                        fill = { bg = "#000000" },
                    },
                    mocha = {
                        background = { fg = mocha.text },
                    },
                    latte = {
                        background = { fg = "#000000" },
                    },
                },
            }),
        })
    end,
}
