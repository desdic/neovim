local M = {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    keys = {{"<Leader>rn", ":IncRename " .. vim.fn.expand("<cword>"), desc = "[R]e[n]ame"}},
    config = {input_buffer_type = "dressing"}
}

return M
