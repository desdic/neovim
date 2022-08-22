local ls = require("luasnip")
local s = ls.s
local i = ls.i
-- local t = ls.t
local fmt = require("luasnip.extras.fmt").fmt
-- local d = ls.dynamic_node
-- local c = ls.choice_node
-- local f = ls.function_node
-- local sn = ls.snippet_node
-- local rep = require("luasnip.extras").rep

local snippets, autosnippets = {}, {}

local iferrnil = s({trig = "ifn", name = "if err != nil"}, fmt(
                  [[if err != nil {{
	{}
}}
		]], {
        i(1, "name")
    }))
table.insert(snippets, iferrnil)

local ifshort = s({trig = "ifns", name = "short if not nil"}, fmt(
                  [[if err := {}; err != nil {{
	{}
}}
		]], {
        i(1, "name"), i(2, "")
    }))
table.insert(snippets, ifshort)

return snippets, autosnippets
