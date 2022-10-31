local ls = require("luasnip")
local s = ls.s
local i = ls.i
local t = ls.text_node
local d = ls.dynamic_node
local sn = ls.snippet_node
-- local r = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt
local f = ls.function_node

local snippets, autosnippets = {}, {}

local get_debchangelog = function(position)
    return d(position, function()
        local ret = {
            i(1, "mypackage"), t(" ("), i(2, "1"),
            t(") systems-focal systems-jammy; urgency=medium")
        }

        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        for index = #lines, 1, -1 do
            for dname, dversion, dpart in
                string.gmatch(lines[index], "([%w%p]+)%s%((%d+)%)%s(.+)") do
                ret = {i(1, dname), t(" (" .. dversion + 1 .. ") " .. dpart)}
            end
        end
        return sn(nil, ret)
    end, {})
end

local deb = s({trig = "cl", name = "debian changelog"}, fmt([[
{}

  * {}

 -- {} <{}>  {}

            ]], {
    get_debchangelog(1), i(2, "<change>"),
    f(function() return os.getenv("DEBFULLNAME") end),
    f(function() return os.getenv("DEBEMAIL") end),
    f(function() return os.date("%a, %d %b %Y %H:%M:%S %z") end)
}))
table.insert(snippets, deb)

return snippets, autosnippets
