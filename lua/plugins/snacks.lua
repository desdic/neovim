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
        },
        bigfile = { enabled = true },
        statuscolumn = { enabled = true },
        quickfile = { enabled = true },
        indent = {
            enabled = false, -- disables listchars
            animate = { enabled = false },
            scope = { enabled = false },
        },
        image = {
            enabled = false,
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
                    exclude = { ".zig-cache", "vendor", ".cache" },
                })
            end,
            desc = "[F]ind [f]iles",
        },
        {
            "<leader>fg",
            mode = { "n" },
            function()
                require("snacks").picker.grep({ exclude = { "vendor", ".cache" } })
            end,
            desc = "[F]ile [g]rep",
        },
        {
            "<leader>fg",
            mode = { "x" },
            function()
                require("snacks").picker.grep_word({ exclude = { "vendor", ".cache" } })
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
        {
            "<leader>bd",
            function()
                require("snacks").bufdelete()
            end,
            { desc = "[D]elete [b]buffer without disrupting window layout" },
        },
    },
}
