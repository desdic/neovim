local ls = require("luasnip")
local s = ls.s
local i = ls.i
local t = ls.t
-- local fmt = require("luasnip.extras.fmt").fmt
local d = ls.dynamic_node
local c = ls.choice_node
-- local f = ls.function_node
local sn = ls.snippet_node
-- local rep = require("luasnip.extras").rep

local file_begin = function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    return row == 1 and col == 1
end

local get_file_type = function(position)
    return d(position, function()
        local ftype = vim.bo.filetype
        local nodes = {}
        if ftype == "python" then table.insert(nodes, t("python3")) end
        table.insert(nodes, t(ftype))
        return sn(nil, {
            c(1, {t("#!/usr/bin/env "), t("#!/sbin/env ")}), c(2, nodes),
            t({"", "", ""}), i(3, "")
        })
    end, {})
end

local snippets, autosnippets = {}, {}

local all = ls.parser.parse_snippet(
                {trig = "$file$", name = "Current filename"}, "$TM_FILENAME")
table.insert(snippets, all)

local fs = s({trig = "#!", name = "Shebang"}, get_file_type(1),
             {condition = file_begin, show_condition = file_begin})
table.insert(snippets, fs)

return snippets, autosnippets
