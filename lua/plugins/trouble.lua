return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
        {
            "<leader>xx",
            function()
                require("trouble").toggle()
            end,
            desc = "Toggle trouble",
        },
        {
            "<leader>xw",
            function()
                require("trouble").toggle("workspace_diagnostics")
            end,
            desc = "Trouble workspace",
        },
        {
            "<leader>xd",
            function()
                require("trouble").toggle("document_diagnostics")
            end,
            desc = "Trouble document ",
        },
        {
            "<leader>xq",
            function()
                require("trouble").toggle("quickfix")
            end,
            desc = "Trouble quickfix ",
        },
        {
            "<leader>xl",
            function()
                require("trouble").toggle("loclist")
            end,
            desc = "Trouble loclist ",
        },
        {
            "gR",
            function()
                require("trouble").toggle("lsp_references")
            end,
            desc = "Trouble LSP references ",
        },
    },
}
