return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = { "VeryLazy" },
    cmd = "FzfLua",
    keys = {
        {
            "<leader>fv",
            function()
                require("fzf-lua").live_grep({ cwd = "~/.config/nvim" })
            end,
            desc = "[Fuzzy] [V]im config",
        },
        {
            "<leader>ff",
            function()
                require("fzf-lua").files()
            end,
            desc = "[F]ind [f]iles",
        },
        {
            "<leader>fg",
            function()
                require("fzf-lua").live_grep_glob()
            end,
            desc = "[F]ile [g]rep",
        },
        {
            "<leader>fw",
            function()
                require("fzf-lua").grep_cword()
            end,
            desc = "[F]ile [w]word grep",
        },
        {
            "<leader>fl",
            function()
                require("fzf-lua").lgrep_curbuf()
            end,
            desc = "Grep current buffer",
        },
        {
            "<leader>fn",
            function()
                require("fzf-lua").live_grep({ cwd = "~/notes" })
            end,
            desc = "[F]uzzy [N]otes search",
        },
        {
            "<leader>fh",
            function()
                require("fzf-lua").help_tags()
            end,
            desc = "[F]uzzy [H]elp tags",
        },
        {
            "<leader>fb",
            function()
                require("fzf-lua").buffers()
            end,
            desc = "[F]ind [b]buffer",
        },
        {
            "z=",
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
            desc = "Spell suggest",
        },
    },

    opts = function()
        local config = require("fzf-lua.config")

        config.defaults.actions.files["ctrl-r"] = function(_, ctx)
            local opts = vim.deepcopy(ctx.__call_opts)

            opts.buf = ctx.__CTX.bufnr
            if opts.cwd ~= nil then
                opts.cwd = nil
            else
                opts.cwd = vim.fs.dirname(vim.fs.find({ ".git", "go.mod" }, { upward = true })[1])
            end
            require("fzf-lua").files(opts)
        end
        config.set_action_helpstr(config.defaults.actions.files["ctrl-r"], "toggle-dir")

        return {
            files = {
                formatter = "path.dirname_first",
                fd_opts = [[--color=never --type f --hidden --exclude .git]],
            },
            ui_select = function(fzf_opts, items)
                return vim.tbl_deep_extend("force", fzf_opts, {
                    prompt = " ",
                    winopts = {
                        title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
                        title_pos = "center",
                    },
                }, fzf_opts.kind == "codeaction" and {
                    winopts = {
                        layout = "vertical",
                        -- height is number of items minus 15 lines for the preview, with a max of 80% screen height
                        height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5) + 16,
                        width = 0.5,
                    },
                } or {
                    winopts = {
                        width = 0.5,
                        -- height is number of items, with a max of 80% screen height
                        height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
                    },
                })
            end,
            winopts = {
                layout = "vertical",
                width = 0.8,
                height = 0.8,
                row = 0.5,
                col = 0.5,
                preview = {
                    scrollchars = { "┃", "" },
                },
            },
            keymap = {
                builtin = {
                    ["<M-S-j>"] = "preview-page-down",
                    ["<M-S-k>"] = "preview-page-up",
                },
            },
        }
    end,

    config = function(_, opts)
        require("fzf-lua").setup(opts)
    end,
}
