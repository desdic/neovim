return {
    "desdic/macrothis.nvim",
    opts = { default_register = "a" },
    keys = {
        {
            "<leader>kkd",
            function()
                require("macrothis").delete()
            end,
            desc = "delete",
        },
        {
            "<leader>kke",
            function()
                require("macrothis").edit()
            end,
            desc = "edit",
        },
        {
            "<leader>kkl",
            function()
                require("macrothis").load()
            end,
            desc = "load",
        },
        {
            "<leader>kkn",
            function()
                require("macrothis").rename()
            end,
            desc = "rename",
        },
        {
            "<leader>kkq",
            function()
                require("macrothis").quickfix()
            end,
            desc = "run macro on all files in quickfix",
        },
        {
            "<leader>kkr",
            function()
                require("macrothis").run()
            end,
            desc = "run macro",
        },
        {
            "<leader>kks",
            function()
                require("macrothis").save()
            end,
            desc = "save",
        },
        {
            "<leader>kkx",
            function()
                require("macrothis").register()
            end,
            desc = "edit register",
        },
        {
            "<leader>kkp",
            function()
                require("macrothis").copy_register_printable()
            end,
            desc = "Copy register as printable",
        },
        {
            "<leader>kkm",
            function()
                require("macrothis").copy_macro_printable()
            end,
            desc = "Copy macro as printable",
        },
    },
}
