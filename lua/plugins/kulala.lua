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
            desc = "Run URL",
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
