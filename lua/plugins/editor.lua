return {
    {
        "ggandor/leap.nvim",
        event = "BufReadPost",
        opts = {},
        keys = {
            {
                "s",
                function()
                    require("leap").leap({
                        target_windows = vim.tbl_filter(function(win)
                            return vim.api.nvim_win_get_config(win).focusable
                        end, vim.api.nvim_tabpage_list_wins(0))
                    })
                end,
                desc = "[S]earch"
            }, {
                "vo", function()
                    local winid = vim.api.nvim_get_current_win()
                    require("leap").leap({
                        target_windows = {winid},
                        targets = require("utils/lines").get_line_starts(winid)
                    })
                    vim.schedule(function() vim.cmd([[norm o]]) end)
                    vim.schedule(function() vim.cmd([[startinsert]]) end)
                end
            }
        },
        config = function(_, opts)
            local leap = require("leap")
            for k, v in pairs(opts) do leap.opts[k] = v end
        end
    }, {
        "echasnovski/mini.bufremove",
        event = "VeryLazy",
        keys = {
            {"<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "[B]uffer [d]elete"},
            {"<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "[B]uffer [d]elete force"}
        },
        config = function() require("mini.bufremove").setup() end
    }, {
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
                line_up = "<M-S-k>"
            }
        },
        config = function(_, opts) require("mini.move").setup(opts) end
    }, {
        "AckslD/nvim-neoclip.lua",
        opts = {},
        keys = {{"<Leader>bp", ":Telescope neoclip unnamed<CR>", desc = "Show clipboard buffers"}}
    }, {
        "smjonas/inc-rename.nvim",
        cmd = "IncRename",
        keys = {{"<Leader>rn", ":IncRename " .. vim.fn.expand("<cword>"), desc = "[R]e[n]ame"}},
        opts = {input_buffer_type = "dressing"}
    }, {
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
                desc = "Peek (Markdown Preview)"
            }
        },
        config = function(_, opts) require("peek").setup(opts) end
    }, {
        "akinsho/toggleterm.nvim",
        cmd = "ToggleTerm",
        keys = {{"<c-t>", ":ToggleTerm", desc = "Toggle term"}},

        config = function()
            require("toggleterm").setup({
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
                float_opts = {border = "curved", winblend = 0, highlights = {border = "Normal", background = "Normal"}}
            })

            function _G.set_terminal_keymaps()
                vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], {noremap = true, buffer = 0, desc = "Esc in terminal"})
                vim.keymap.set("t", "jk", [[<C-\><C-n>]], {noremap = true, buffer = 0, desc = "Esc in terminal"})
                vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]],
                               {noremap = true, buffer = 0, desc = "Navigate to left window"})
                vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]],
                               {noremap = true, buffer = 0, desc = "Navigate to window below"})
                vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]],
                               {noremap = true, buffer = 0, desc = "Navigate to window above"})
                vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]],
                               {noremap = true, buffer = 0, desc = "Navigate to right window"})
            end

            vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
        end
    }, {
        "nvim-tree/nvim-tree.lua",
        event = "VeryLazy",
        keys = {{"<Leader>n", ":NvimTreeToggle<CR>", desc = "Start file browser"}},
        dependencies = {{"nvim-tree/nvim-web-devicons"}},

        config = function()
            -- recommended settings from nvim-tree documentation
            vim.g.loaded = 1
            vim.g.loaded_netrwPlugin = 1

            -- change color for arrows in tree to light blue
            -- vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

            -- configure nvim-tree
            require("nvim-tree").setup({
                renderer = {icons = {glyphs = {folder = {arrow_closed = "", arrow_open = ""}}}},
                actions = {open_file = {window_picker = {enable = false}}},
                git = {ignore = false}
            })
        end
    }, {
        "ThePrimeagen/harpoon",
        event = "VeryLazy",
        opts = {},
        keys = {
            {"<Leader>a", function() require("harpoon.mark").add_file() end, desc = "Add file to harpoon"},
            {"<Leader>z", function() require("harpoon.ui").nav_next() end, desc = "Next file in harpoon"},
            {"<Leader>x", function() require("harpoon.ui").nav_prev() end, desc = "Previous file in harpoon"},
            {"<Leader>1", function() require("harpoon.ui").nav_file(1) end, desc = "file 1"},
            {"<Leader>2", function() require("harpoon.ui").nav_file(2) end, desc = "file 2"},
            {"<Leader>3", function() require("harpoon.ui").nav_file(3) end, desc = "file 3"},
            {"<Leader>4", function() require("harpoon.ui").nav_file(4) end, desc = "file 4"}
        },
        config = function(_, opts) end
    }, {
        "RRethy/vim-illuminate",
        event = "BufReadPost",
        opts = {delay = 200, filetypes_denylist = {"NvimTree", "alpha"}},
        config = function(_, opts) require("illuminate").configure(opts) end,
        keys = {
            {"]]", function() require("illuminate").goto_next_reference(false) end, desc = "Next Reference"},
            {"[[", function() require("illuminate").goto_prev_reference(false) end, desc = "Prev Reference"}
        }
    }, {"luukvbaal/stabilize.nvim", config = function() require("stabilize").setup() end} -- not needed in nvim 0.9
}
