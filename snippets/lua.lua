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

local pcallf = s(
    { trig = "pcallguard", name = "protective guard" },
    fmt(
        [[local {}, {} = pcall(require, "{}")
if not {} then
    vim.notify("Unable to require {}", vim.lsp.log_levels.ERROR,
               {{title = "Plugin error"}})
    return
end

{}
        ]],
        { i(1, "ok"), i(2, "fn"), i(3, "library"), rep(1), rep(3), i(0) }
    )
)
table.insert(snippets, pcallf)

return snippets, autosnippets
