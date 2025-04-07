return {
    "desdic/agrolens.nvim",
    dependencies = {
        "folke/snacks.nvim",
    },
    opts = {
        debug = false,
        force_long_filepath = false,
        same_type = false,
        include_hidden_buffers = false,
        disable_indentation = true,
        aliases = {
            yamllist = "docker-compose,github-workflow-steps",
            work = "cheflxchost,github-workflow-steps,pytest,ipam",
            all = "cheflxchost,pytest,ipam,functions,labels",
        },
    },
    keys = {
        {
            "<leader>ag",
            function()
                require("agrolens").generate({ all_captures = true })
            end,
            desc = "AL generate",
        },
        {
            "zu",
            function()
                require("agrolens.snacks").run({
                    query = "functions,labels",
                })
            end,
            desc = "AL func,label cur buffer",
        },
        {
            "zi",
            function()
                require("agrolens.snacks").run({
                    query = "functions,labels",
                    buffers = "all",
                    same_type = false,
                })
            end,
            desc = "AL func,label all buffers",
        },
        {
            "zo",
            function()
                require("agrolens.snacks").run({
                    query = "callings",
                    buffers = "all",
                    same_type = false,
                    match = "name,object",
                })
            end,
            desc = "AL callings of name",
        },
        {
            "zl",
            function()
                require("agrolens.snacks").run({
                    query = "work",
                })
            end,
            desc = "AL work profile",
        },
        {
            "zc",
            function()
                require("agrolens.snacks").run({
                    query = "comments",
                    buffers = "all",
                    same_type = false,
                })
            end,
            desc = "AL comments",
        },
        {
            "z[",
            function()
                require("agrolens.snacks").run({
                    query = "all",
                    jump = "next",
                })
            end,
            desc = "AL jump next",
        },
        {
            "z]",
            function()
                require("agrolens.snacks").run({
                    query = "all",
                    jump = "prev",
                })
            end,
            desc = "AL jump previous",
        },
    },
}
