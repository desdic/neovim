local M = {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
        {
            "<Leader>ff",
            function()
                require("telescope.builtin").find_files({hidden = true})
            end,
            desc = "[F]ind [f]iles"
        }, {
            "<Leader>fg",
            function() require("telescope.builtin").live_grep() end,
            desc = "[F]ile [g]rep"
        }, {
            "<Leader>sm",
            function() require("telescope.builtin").marks() end,
            desc = "[S]how [m]arks"
        }, {
            "<Leader>ts",
            function() require("telescope.builtin").treesitter() end,
            desc = "[T]reesitter [s]ymbols"
        }, {
            "<Leader>sb",
            function() require("telescope.builtin").buffers() end,
            desc = "[S]how [b]uffers"
        }, {
            "<Leader>ht",
            function() require("telescope.builtin").help_tags() end,
            desc = "[H]elp [t]ags"
        }, {
            "<Leader>ln",
            function()
                require("telescope").extensions.notify.notify({})
            end,
            desc = "[L]ist [n]otifications"
        }, {
            "<Leader>fs",
            function()
                require("telescope.builtin").current_buffer_fuzzy_find()
            end,
            desc = "[F]uzzy [s]earch"
        }, {
            "<Leader>gS",
            function() require("telescope.builtin").git_status() end,
            desc = "[G]it [s]tatus"
        },
        {
            "<Leader>hm",
            ":Telescope harpoon marks<CR>",
            desc = "[H]arpoon [m]arks"
        }
    },
    dependencies = {
        {"nvim-telescope/telescope-fzy-native.nvim"},
        {"nvim-telescope/telescope-ui-select.nvim"},
        {"desdic/telescope-rooter.nvim"}, {"nvim-lua/plenary.nvim"},
        {"kyazdani42/nvim-web-devicons"}
    }
}

function M.config()
    local ts = require("telescope")

    local actions = require("telescope.actions")

    local tsbuildin = require("telescope.builtin")

    ts.setup({
        defaults = {
            file_ignore_patterns = {".git/", ".cache/", "vendor"},
            prompt_prefix = " ",
            selection_caret = " ",
            path_display = {"smart"},

            mappings = {
                i = {
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-q>"] = actions.smart_send_to_qflist +
                        actions.open_qflist,
                    ["<esc>"] = actions.close
                    -- ["<CR>"] = actions.select_default + actions.center,

                    -- You can perform as many actions in a row as you like
                    -- ["<CR>"] = actions.select_default + actions.center + my_cool_custom_action,
                    -- ["<C-h>"] = actions.which_key -- keys from pressing <C-/>
                },
                n = {
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous
                    -- ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                    -- ["<C-h>"] = actions.which_key
                }
            }
        },
        extensions = {
            fzy_native = {
                override_generic_sorter = false,
                override_file_sorter = true
            },
            rooter = {patterns = {".git", "go.sum"}}
        }
    })

    ts.load_extension("fzy_native")
    ts.load_extension("harpoon")
    ts.load_extension("rooter")

    local F = {}

    F.find_files = function()
        tsbuildin.find_files({
            find_command = {"fd", "-t=f", "-a"},
            -- path_display = {"absolute"},
            wrap_results = true
            -- previewer = false
        })
    end

    F.search_nvim = function()
        tsbuildin.find_files({
            prompt_title = "< VimRC >",
            cwd = "$HOME/.config/nvim/"
        })
    end

    function F.grep_notes()
        local optsgrep = {}
        optsgrep.search_dirs = {"~/notes/"}
        optsgrep.prompt_prefix = "   "
        optsgrep.prompt_title = "Search Notes"
        tsbuildin.live_grep(optsgrep)
    end

    vim.keymap.set("n", "<Leader>vrc", function() F.search_nvim() end, {
        noremap = true,
        silent = true,
        desc = "Search in neovim config"
    })

    vim.keymap.set("n", "<Leader>notes", function() F.grep_notes() end,
                   {noremap = true, silent = true, desc = "Search in notes"})

    return F
end

return M
