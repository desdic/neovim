return {
    "mistweaverco/kulala.nvim",
    opts = {
        additional_curl_options = { "-n" },
    },
    keys = {
        {
            "<leader>Rs",
            function()
                require("kulala").run()
            end,
            desc = "Run request",
        },
        {
            "<leader>Ra",
            function()
                require("kulala").run_all()
            end,
            desc = "Run all request",
        },
        {
            "<leader>Rt",
            function()
                require("kulala").toggle_view()
            end,
            desc = "Toggle view",
        },
        {
            "<leader>Rr",
            function()
                require("kulala").replay()
            end,
            desc = "Replay requests",
        },
    },
}
