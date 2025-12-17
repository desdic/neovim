local ls = require("luasnip")
local s = ls.s
local i = ls.i
local t = ls.t
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippets, autosnippets = {}, {}

local func = s(
    { trig = "(%S+)t", regTrig = true },
    fmt(
        [[
    func {}({}) {}{{
    {}{}
    }}

    ]],
        {
            f(function(_, snip)
                return snip.captures[1]
            end, {}),
            i(1),
            i(2),
            t({ "\t" }),
            i(0),
        }
    )
)

table.insert(snippets, func)

return snippets, autosnippets
