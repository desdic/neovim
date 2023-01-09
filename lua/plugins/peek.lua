local M = {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    opts = {},

    keys = {
        {
            "<Leader>op",
            function()
                local peek = require("peek")
                if peek.is_open() then
                    peek.close()
                else
                    peek.open()
                end
            end,
            desc = "Peek (Markdown Preview)"
        }
    }
}

return M
