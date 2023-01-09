local M = {
    "beauwilliams/focus.nvim",
    opts = {enable = true, cursorline = false, signcolumn = true, number = false, excluded_filetypes = {"toggleterm"}},
    keys = {
        {"<Leader>sl", function() require("focus").split_command("h") end, desc = "[S]plit window [l]eft"},
        {"<Leader>sr", function() require("focus").split_command("l") end, desc = "[S]plit window [r]ight"}
    }
}

return M
