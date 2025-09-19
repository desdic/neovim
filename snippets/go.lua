local ls = require("luasnip")
local s = ls.s
local i = ls.i
local t = ls.t
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippets, autosnippets = {}, {}

local main = s(
    { trig = "main", name = "main" },
    fmt(
        [[
package main

func main() {{
{}{}
}}
        ]],
        {

            t({ "\t" }),
            i(0),
        }
    )
)

table.insert(snippets, main)

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

local camelize = s(
    { trig = "(%S+)c", regTrig = true },
    fmt([[{}]], {
        f(function(_, snip)
            local str = snip.captures[1]

            str = str:gsub("^%a", string.lower)
            str = str:gsub("_(%a)", function(letter)
                return letter:upper()
            end)

            return str
        end, {}),
    })
)

table.insert(snippets, camelize)

return snippets, autosnippets
