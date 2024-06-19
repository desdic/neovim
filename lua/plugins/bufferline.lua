return {
    "akinsho/nvim-bufferline.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    keys = {
        { "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Move to next buffer" },
        { "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Move to previous buffer" },
    },
    config = function(_, _)
        require("bufferline").setup({
            options = {
                show_buffer_close_icons = false,
                show_close_icon = false,
                persist_buffer_sort = true,
            },
        })
        -- Fix bufferline when restoring a session
        vim.api.nvim_create_autocmd("BufAdd", {
            callback = function()
                vim.schedule(function()
                    ---@diagnostic disable-next-line: undefined-global
                    pcall(nvim_bufferline)
                end)
            end,
        })
    end,
}
