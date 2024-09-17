return {
    "mistweaverco/kulala.nvim",
    opts = {
        additional_curl_options = { "-n" },
    },
    keys = {
        {
            "<leader>kr",
            function()
                require("kulala").run()
            end,
            desc = "Run request",
        },
        {
            "<leader>kw",
            function()
                require("kulala").run_all()
            end,
            desc = "Run all request",
        },
        {
            "<leader>kt",
            function()
                require("kulala").toggle_view()
            end,
            desc = "Toggle view",
        },
    },
}
