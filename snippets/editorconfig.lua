local ls = require("luasnip")
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt

local snippets, autosnippets = {}, {}

local main = s(
    { trig = "main", name = "main" },
    fmt(
        [[
# EditorConfig https://EditorConfig.org

root = true

[*]
indent_style = tab
indent_size = 4
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.{{yml,yaml,json}}]
indent_style = space
indent_size = 2
        ]],
        {}
    )
)

table.insert(snippets, main)

return snippets, autosnippets
