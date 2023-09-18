return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            search = {
                filetype_exclude = { "notify" },
            },
            modes = {
                search = {
                    enabled = false -- disable for search
                },
                char = {
                    enabled = false -- disable for fFtT
                }
            }
        },
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
            },
            {
                "S",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter()
                end,
            },
        },
    },
    {
        "echasnovski/mini.bufremove",
        event = "VeryLazy",
        keys = {
            {
                "<leader>bd",
                function()
                    require("mini.bufremove").delete(0, false)
                end,
                desc = "[B]uffer [d]elete",
            },
            {
                "<leader>bD",
                function()
                    require("mini.bufremove").delete(0, true)
                end,
                desc = "[B]uffer [d]elete force",
            },
        },
        config = function()
            require("mini.bufremove").setup()
        end,
    },
    {
        "echasnovski/mini.move",
        event = "BufEnter",
        opts = {
            mappings = {
                -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
                left = "<M-S-h>",
                right = "<M-S-l>",
                down = "<M-S-j>",
                up = "<M-S-k>",

                -- Move current line in Normal mode
                line_left = "<M-S-h>",
                line_right = "<M-S-l>",
                line_down = "<M-S-j>",
                line_up = "<M-S-k>",
            },
        },
        config = function(_, opts)
            require("mini.move").setup(opts)
        end,
    },
    {
        "smjonas/inc-rename.nvim",
        cmd = "IncRename",
        keys = { { "<Leader>rn", ":IncRename " .. vim.fn.expand("<cword>"), desc = "[R]e[n]ame" } },
        opts = { input_buffer_type = "dressing" },
    },
    {
        "ellisonleao/glow.nvim",
        opts = {
            style = "dark",
            width = 180,
        },
        cmd = "Glow",
        keys = {
            { "<Leader>op", "<cmd>Glow<CR>" }
        }
    },
    {
        "akinsho/toggleterm.nvim",
        cmd = "ToggleTerm",
        keys = { { "<c-t>", "<cmd>ToggleTerm", desc = "Toggle term" } },
        opts = {
            size = 20,
            open_mapping = [[<c-t>]],
            hide_numbers = true,
            shade_filetypes = {},
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = true,
            persist_size = true,
            direction = "float",
            close_on_exit = true,
            shell = vim.o.shell,
            float_opts = {
                border = "curved",
                winblend = 0,
                highlights = { border = "Normal", background = "Normal" },
            },
        },
        config = function(_, opts)
            require("toggleterm").setup(opts)

            ---@diagnostic disable-next-line: duplicate-set-field
            function _G.set_terminal_keymaps()
                vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { noremap = true, buffer = 0, desc = "Esc in terminal" })
                vim.keymap.set("t", "jk", [[<C-\><C-n>]], { noremap = true, buffer = 0, desc = "Esc in terminal" })
                vim.keymap.set(
                    "t",
                    "<C-h>",
                    [[<C-\><C-n><C-W>h]],
                    { noremap = true, buffer = 0, desc = "Navigate to left window" }
                )
                vim.keymap.set(
                    "t",
                    "<C-j>",
                    [[<C-\><C-n><C-W>j]],
                    { noremap = true, buffer = 0, desc = "Navigate to window below" }
                )
                vim.keymap.set(
                    "t",
                    "<C-k>",
                    [[<C-\><C-n><C-W>k]],
                    { noremap = true, buffer = 0, desc = "Navigate to window above" }
                )
                vim.keymap.set(
                    "t",
                    "<C-l>",
                    [[<C-\><C-n><C-W>l]],
                    { noremap = true, buffer = 0, desc = "Navigate to right window" }
                )
            end

            vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
        end,
    }
}
