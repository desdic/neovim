return {
    "folke/snacks.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    priority = 1000,
    lazy = false,
    opts = {
        input = { enabled = true, relative = "cursor", row = -3, col = 0 },
        notifier = { enabled = true },
        lazygit = { enabled = true },
        picker = {
            enabled = true,
            formatters = {
                file = {
                    truncate = 120,
                },
            },

            layout = {
                layout = {
                    min_width = 180,
                },
            },
            win = {
                input = {
                    keys = {
                        ["<a-s>"] = { "flash", mode = { "n", "i" } },
                        ["s"] = { "flash" },
                    },
                },
            },
            actions = {
                flash = function(picker)
                    require("flash").jump({
                        pattern = "^",
                        label = { after = { 0, 0 } },
                        search = {
                            mode = "search",
                            exclude = {
                                function(win)
                                    return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
                                end,
                            },
                        },
                        action = function(match)
                            local idx = picker.list:row2idx(match.pos[1])
                            picker.list:_move(idx, true, true)
                        end,
                    })
                end,
            },
        },
        bigfile = { enabled = true },
        statuscolumn = { enabled = true },
        quickfile = { enabled = true },
        indent = {
            enabled = true,
            animate = { enabled = false },
            scope = { enabled = false },
        },
    },
    keys = {
        {
            "<leader>lg",
            function()
                require("snacks").lazygit()
            end,
            desc = "[L]azy[G]it",
        },
        {
            "<leader>ff",
            function()
                require("snacks").picker.files({
                    hidden = true,
                    cwd = vim.fs.dirname(vim.fs.find({ ".git", "go.mod" }, { upward = true })[1]),
                })
            end,
            desc = "[F]ind [f]iles",
        },
        {
            "<leader>fg",
            mode = { "n" },
            function()
                require("snacks").picker.grep()
            end,
            desc = "[F]ile [g]rep",
        },
        {
            "<leader>fg",
            mode = { "x" },
            function()
                require("snacks").picker.grep_word()
            end,
            desc = "[F]ile [g]rep visual word",
        },
        {
            "<leader>fn",
            function()
                require("snacks").picker.grep({ dirs = { "~/notes" } })
            end,
            desc = "[F]uzzy [N]otes search",
        },
        {
            "<leader>fh",
            function()
                require("snacks").picker.help()
            end,
            desc = "[F]uzzy [H]elp tags",
        },
        {
            "<leader>,",
            function()
                require("snacks").picker.buffers()
            end,
            desc = "Buffer",
        },
        {
            "<leader>fv",
            function()
                require("snacks").picker.grep({ dirs = { "~/.config/nvim" } })
            end,
            desc = "[Fuzzy] [V]im config",
        },
        {
            "z=",
            function()
                require("snacks").picker.spelling()
            end,
            desc = "Spell suggest",
        },
        {
            "<leader>gn",
            function()
                require("snacks").picker.notifications()
            end,
            desc = "Notifications",
        },
        {
            "<leader>fu",
            function()
                require("snacks").picker.undo()
            end,
            desc = "Undo tree",
        },
        {
            "<leader>sd",
            function()
                require("snacks").picker.diagnostics()
            end,
            desc = "Diagnostics",
        },
        {
            "<leader>tt",
            mode = { "n", "t" },
            function()
                require("snacks").terminal()
            end,
            { desc = "Toggle term" },
        },
        {
            "<leader>gb",
            function()
                require("snacks").git.blame_line()
            end,
            { desc = "[G]it [b]lame line" },
        },
    },
}
