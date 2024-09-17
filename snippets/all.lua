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
local utils = require("core.utils")

local snippets, autosnippets = {}, {}

local all = ls.parser.parse_snippet({ trig = "$file$", name = "Current filename" }, "$TM_FILENAME")
table.insert(snippets, all)

local get_file_type = function(position)
    return d(position, function()
        local nodes = {}

        local ftype = vim.bo.filetype

        if ftype == "" or ftype == "sh" then
            table.insert(nodes, t("bash"))
            table.insert(nodes, t("sh"))
        elseif ftype == "perl" then
            table.insert(nodes, t("perl"))
        elseif ftype == "python" then
            table.insert(nodes, t("python3"))
            table.insert(nodes, t("python"))
        else
            return sn(nil, { t("#!") })
        end

        return sn(nil, {
            t("#!/usr/bin/env "),
            c(1, nodes),
            t({ "", "", "" }),
            i(0),
        })
    end, {})
end

local fs = s({ trig = "#!" }, get_file_type(1), { condition = utils.is_top_empty_file() })
table.insert(autosnippets, fs)

return snippets, autosnippets
