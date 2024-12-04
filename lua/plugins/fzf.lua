return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = { "VeryLazy" },
    cmd = "FzfLua",
    keys = {
        {
            "<Leader>vrc",
            function()
                require("fzf-lua").live_grep({ cwd = "~/.config/nvim" })
            end,
            desc = "[V]im [c]onfig",
        },
        {
            "<Leader>ff",
            function()
                local rootdir = vim.fs.dirname(vim.fs.find({ ".git", "go.mod" }, { upward = true })[1])
                if rootdir == nil then
                    rootdir = vim.uv.cwd() or "."
                end

                require("fzf-lua").files({ cwd = rootdir })
            end,
            desc = "[F]ind [f]iles",
        },
        {
            "<Leader>fg",
            function()
                require("fzf-lua").live_grep()
            end,
            desc = "[F]ile [g]rep",
        },
        {
            "<Leader>gc",
            function()
                require("fzf-lua").grep_cword()
            end,
            desc = "[F]ile [g]rep",
        },
        {
            "<Leader>no",
            function()
                require("fzf-lua").live_grep({ cwd = "~/notes" })
            end,
            desc = "[N]otes search",
        },
        {
            "<Leader>ht",
            function()
                require("fzf-lua").help_tags()
            end,
            desc = "[H]elp [t]ags",
        },
        {
            "<Leader>fb",
            function()
                require("fzf-lua").buffers()
            end,
            desc = "[F]ind [b]buffer",
        },
        {
            "<Leader>ss",
            function()
                require("fzf-lua").spell_suggest({
                    winopts = {
                        relative = "cursor",
                        row = 1.01,
                        col = 0,
                        height = 0.2,
                        width = 0.2,
                    },
                })
            end,
            desc = "[S]pell [s]uggest",
        },
    },
    config = function()
        local actions = require("fzf-lua.actions")
        local fzf = require("fzf-lua")
        fzf.setup({
            winopts = {
                preview = {
                    default = "bat", -- override the default previewer?
                },
            },
            keymap = {
                builtin = {
                    true, -- inherit from default
                    ["<C-d>"] = "preview-page-down",
                    ["<C-u>"] = "preview-page-up",
                },
                fzf = {
                    true, -- inherit from default
                    ["ctrl-d"] = "preview-page-down",
                    ["ctrl-u"] = "preview-page-up",
                },
            },
            actions = {
                files = {
                    true, -- inherit from default
                    ["enter"] = actions.file_edit,
                },
            },
        })

        fzf.register_ui_select()
    end,
}
