return {
    {
        "ggandor/leap.nvim",
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
        config = function() require("leap").add_default_mappings() end
    }, -- bufremove
    {
        "echasnovski/mini.bufremove",
        event = "VeryLazy",
        keys = {
            {"<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "[B]uffer [d]elete"},
            {"<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "[B]uffer [d]elete force"}
        }
    }, {
        "booperlv/nvim-gomove",
        opts = {map_defaults = false, reindent = true, undojoin = true, move_past_end_col = false},
        keys = {
            {"<S-j>", "<Plug>GoVSMDown", mode = {"x"}, desc = "Move visual line down"},
            {"<S-k>", "<Plug>GoVSMUp", mode = {"x"}, desc = "Move visual line up"},
            {"<S-h>", "<Plug>GoVSMLeft", mode = {"x"}, desc = "Move visual line left"},
            {"<S-l>", "<Plug>GoVSMRight", mode = {"x"}, desc = "Move visual line right"}
        }
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
        }
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
        keys = {{"<Leader>n", ":NvimTreeToggle<CR>", desc = "Start file browser"}},
        dependencies = {{"kyazdani42/nvim-web-devicons"}},

        config = function()
            -- recommended settings from nvim-tree documentation
            vim.g.loaded = 1
            vim.g.loaded_netrwPlugin = 1

            -- change color for arrows in tree to light blue
            -- vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

            -- configure nvim-tree
            require("nvim-tree").setup({
                renderer = {icons = {glyphs = {folder = {arrow_closed = "", arrow_open = ""}}}},
                actions = {open_file = {window_picker = {enable = false}}}
            })
        end
    }, {
        "ThePrimeagen/harpoon",
        cmd = "Harpoon",
        opts = {},
        keys = {
            {"<Leader>a", ":Harpoon add_file<CR>", desc = "Add file to harpoon"},
            {"<Leader>/", ":Harpoon nav_next<CR>", desc = "Next file in harpoon"},
            {"<Leader>.", ":Harpoon nav_prev<CR>", desc = "Previous file in harpoon"},
            {"<Leader>1", ":Harpoon file1<CR>", desc = "file 1"}, {"<Leader>2", ":Harpoon file2<CR>", desc = "file2"},
            {"<Leader>3", ":Harpoon file3<CR>", desc = "file 3"}, {"<Leader>4", ":Harpoon file4<CR>", desc = "file 4"}
        },
        config = function()
            vim.api.nvim_create_user_command("Harpoon", function(args)
                if args.args == "add_file" then
                    require("harpoon.mark").add_file()
                elseif args.args == "nav_next" then
                    require("harpoon.ui").nav_next()
                elseif args.args == "nav_prev" then
                    require("harpoon.ui").nav_prev()
                elseif args.args == "nav_prev" then
                    require("harpoon.ui").nav_prev()
                elseif args.args == "file1" then
                    require("harpoon.ui").nav_file(1)
                elseif args.args == "file2" then
                    require("harpoon.ui").nav_file(2)
                elseif args.args == "file3" then
                    require("harpoon.ui").nav_file(3)
                elseif args.args == "file4" then
                    require("harpoon.ui").nav_file(4)
                end
            end, {nargs = "*", desc = "Run harpoon"})
        end
    }
}