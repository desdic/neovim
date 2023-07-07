return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            search = {
                filetype_exclude = { "notify", "noice" },
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
        opts = { input_buffer_type = "noice" },
    },
    {
        "toppair/peek.nvim",
        build = "deno task --quiet build:fast",
        opts = {},
        keys = {
            {
                "<Leader>op",
                function()
                    local peek = require("peek")
                    if peek.is_open() then
                        peek.close()
                    else
                        peek.open()
                    end
                end,
                desc = "Peek (Markdown Preview)",
            },
        },
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
            -- direction = "horizontal",
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
    },
    {
        "nvim-tree/nvim-tree.lua",
        event = "VeryLazy",
        keys = { { "<Leader>n", "<cmd>NvimTreeToggle<CR>", desc = "Start file browser" } },
        dependencies = { { "nvim-tree/nvim-web-devicons" } },

        config = function()
            -- recommended settings from nvim-tree documentation
            vim.g.loaded = 1
            vim.g.loaded_netrwPlugin = 1

            -- change color for arrows in tree to light blue
            -- vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

            -- configure nvim-tree
            require("nvim-tree").setup({
                renderer = { icons = { glyphs = { folder = { arrow_closed = "󰁕", arrow_open = "󰁆" } } } },
                actions = { open_file = { window_picker = { enable = false } } },
                git = { ignore = false },
            })
        end,
    },
}
