return {
    "smjonas/inc-rename.nvim",
    dependencies = { "stevearc/dressing.nvim" },
    cmd = "IncRename",
    keys = { { "<Leader>rn", function() return ":IncRename " .. vim.fn.expand("<cword>") end, expr = true, desc = "[R]e[n]ame" } },
    opts = { input_buffer_type = "dressing" },
}
