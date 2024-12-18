return {
    "desdic/macrothis.nvim",
    opts = { default_register = "a" },
    keys = {
        {
            "<Leader>kkd",
            function()
                require("macrothis").delete()
            end,
            desc = "delete",
        },
        {
            "<Leader>kke",
            function()
                require("macrothis").edit()
            end,
            desc = "edit",
        },
        {
            "<Leader>kkl",
            function()
                require("macrothis").load()
            end,
            desc = "load",
        },
        {
            "<Leader>kkn",
            function()
                require("macrothis").rename()
            end,
            desc = "rename",
        },
        {
            "<Leader>kkq",
            function()
                require("macrothis").quickfix()
            end,
            desc = "run macro on all files in quickfix",
        },
        {
            "<Leader>kkr",
            function()
                require("macrothis").run()
            end,
            desc = "run macro",
        },
        {
            "<Leader>kks",
            function()
                require("macrothis").save()
            end,
            desc = "save",
        },
        {
            "<Leader>kkx",
            function()
                require("macrothis").register()
            end,
            desc = "edit register",
        },
        {
            "<Leader>kkp",
            function()
                require("macrothis").copy_register_printable()
            end,
            desc = "Copy register as printable",
        },
        {
            "<Leader>kkm",
            function()
                require("macrothis").copy_macro_printable()
            end,
            desc = "Copy macro as printable",
        },
    },
}
