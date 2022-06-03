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

local def = s({trig = "def", name="definition"}, fmt([[def {}({}) -> {}:
	{}
		]], {
    i(1, "name"), i(2), i(3, "None"),
    i(0, 'raise NotImplementedError("To be implemented")')
}))
table.insert(snippets, def)

return snippets, autosnippets
