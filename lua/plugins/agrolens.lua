return {
    "desdic/agrolens.nvim",
    dev = true,
    keys = {
        {
            "ag",
            function()
                require("agrolens").generate({ all_captures = true })
            end,
            desc = "Agrolens"
        },
    },
}
