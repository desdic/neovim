local M = {"echasnovski/mini.nvim", event = "VeryLazy", dependencies = {"JoosepAlviste/nvim-ts-context-commentstring"}}

function M.pairs() require("mini.pairs").setup({}) end

function M.comment()
    require("mini.comment").setup({
        hooks = {pre = function() require("ts_context_commentstring.internal").update_commentstring({}) end}
    })
end

function M.surround()
    require("mini.surround").setup({
        mappings = {
            add = "gza", -- Add surrounding in Normal and Visual modes
            delete = "gzd", -- Delete surrounding
            find = "gzf", -- Find surrounding (to the right)
            find_left = "gzF", -- Find surrounding (to the left)
            highlight = "gzh", -- Highlight surrounding
            replace = "gzr", -- Replace surrounding
            update_n_lines = "gzn" -- Update `n_lines`
        }
    })
end

function M.init()
    vim.keymap.set("n", "<leader>bd", function() require("mini.bufremove").delete(0, false) end)
    vim.keymap.set("n", "<leader>bD", function() require("mini.bufremove").delete(0, true) end)
end

function M.config()
    M.pairs()
    M.comment()
    M.surround()
end

return M
