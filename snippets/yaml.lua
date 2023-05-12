local ls = require("luasnip")
local s = ls.s
local i = ls.i
-- local t = ls.t
local fmt = require("luasnip.extras.fmt").fmt
-- local d = ls.dynamic_node
-- local c = ls.choice_node
-- local f = ls.function_node
-- local sn = ls.snippet_node
local rep = require("luasnip.extras").rep

local snippets, autosnippets = {}, {}

local acme = s(
    { trig = "_acme", name = "octo dns acme" },
    fmt(
        [[
_acme-challenge.{}:
  type: CNAME
  value: _acme-challenge.{}.{}.transient.{}.
        ]],
        { i(1, "myhost"), rep(1), i(2, "example.com"), rep(2)}
    )
)
table.insert(snippets, acme)

return snippets, autosnippets
