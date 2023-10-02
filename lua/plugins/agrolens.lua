return {
    "desdic/agrolens.nvim",
    keys = {
        {
            "ag",
            function()
                require("agrolens").generate({ all_captures = true })
            end,
        },
    },
}
