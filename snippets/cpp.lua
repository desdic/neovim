local ls = require("luasnip")
local s = ls.s
local i = ls.i
local d = ls.dynamic_node
local sn = ls.snippet_node
local r = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

local upper_filename = function()
    -- Uppercase current filename and wrap in underscope
    local filename =
        "__" .. string.upper(vim.fn.expand("%:t"):gsub("%.", "_")) .. "__"
    return sn(nil, i(1, filename))
end

local snippets, autosnippets = {}, {}

local guard = s({trig = "#ifndef", name = "header guard"}, fmt([[
#ifndef {}
#define {}

{}

#endif
		]], {d(1, upper_filename, {}), r(1), i(0)}))

table.insert(snippets, guard)

return snippets, autosnippets
