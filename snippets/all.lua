local ls = require("luasnip")
local s = ls.s
local i = ls.i
local fmt = require("luasnip.extras.fmt").fmt

local snippets, autosnippets = {}, {}

local ticks = s(
    { trig = "`", name = "wrap in backticks" },
    fmt(
        [[```{}
{}
```
        ]],
        { i(1), i(0) }
    )
)

table.insert(snippets, ticks)

return snippets, autosnippets
