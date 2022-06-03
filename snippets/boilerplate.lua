-- Boilerplate for snippet
local ls = require("luasnip")
local s = ls.s
local i = ls.i
local t = ls.t
local c = ls.choice_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local r = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local snippets, autosnippets = {}, {}

local test = s({trig = "test", name = "test"}, t("test"))

table.insert(snippets, test)

return snippets, autosnippets
