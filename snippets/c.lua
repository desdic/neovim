local ls = require("luasnip")
local s = ls.s
local i = ls.i
local t = ls.t
local fmt = require("luasnip.extras.fmt").fmt
local c = ls.choice_node

local snippets, autosnippets = {}, {}

local main = s(
    { trig = "main", name = "main" },
    fmt(
        [[
int main({}) {{
{}{}
{}return 0;
}}
        ]],
        {
            c(1, { t("void"), t("int argc, char *argv[]") }),
            t({ "\t" }),
            i(0),
            t({ "\t" }),
        }
    )
)

table.insert(snippets, main)

return snippets, autosnippets
