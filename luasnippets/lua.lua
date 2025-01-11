local ls = require("luasnip")
local s = ls.s
local i = ls.i
local r = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

local snippets, autosnippets = {}, {}

local print_inspect = s(
    { trig = "print.inspect", name = "print inspect" },
    fmt(
        [[
print(vim.inspect({}))
{}
        ]],
        { i(1), i(0) }
    )
)

table.insert(snippets, print_inspect)

local print_meta = s(
    { trig = "print.meta", name = "print metatable" },
    fmt(
        [[
print(vim.inspect(getmetatable({})))
{}
        ]],
        { i(1), i(0) }
    )
)

table.insert(snippets, print_meta)

local pcallguard = s(
    { trig = "pcallguard", name = "pcallguard" },
    fmt(
        [[
local {}, {} = pcall(require, "{}")
if not {} then
  vim.notify("Unable to require {}", vim.lsp.log_levels.ERROR,
             {{title = "Plugin error"}})
  return
end
{}
        ]],
        { i(1, "ok"), i(2, "fn"), i(3, "library"), r(1), r(3), i(0) }
    )
)

table.insert(snippets, pcallguard)

return snippets, autosnippets
