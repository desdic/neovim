local ls = require("luasnip")
local s = ls.s
local i = ls.i
local t = ls.text_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local f = ls.function_node
local c = ls.choice_node

local snippets, autosnippets = {}, {}

local get_debchangelog = function(position)
    return d(position, function()
        local ret = {
            i(1, "mypackage"),
            t(" ("),
            i(2, "0.0.1"),
            t(") systems-jammy systems-noble; urgency=medium"),
        }

        local latest = t("systems-jammy systems-noble")
        local second = t("systems-focal systems-jammy systems-noble")

        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        for _, line in ipairs(lines) do
            for package, version, systems, urgency in line:gmatch("([%w%.%-]+) %(([%w%-%.]+)%) (.-); urgency=([%w]+)") do
                local new_version = version:gsub("(%D)(%d+)$", function(prefix, last_number)
                    return prefix .. (tonumber(last_number) + 1)
                end)

                ret = {
                    i(1, package),
                    i(2, " ("),
                    i(2, new_version),
                    t(") "),
                    c(3, { t(systems), latest, second }),
                    t("; urgency=" .. urgency),
                }
                return sn(nil, ret)
            end
        end
        return sn(nil, ret)
    end, {})
end

local deb = s(
    { trig = "changelog", name = "debian changelog" },
    fmt(
        [[
{}

  * {}

 -- {} <{}>  {}

            ]],
        {
            get_debchangelog(1),
            i(2, "<change>"),
            f(function()
                return os.getenv("DEBFULLNAME")
            end),
            f(function()
                return os.getenv("DEBEMAIL")
            end),
            f(function()
                return os.date("%a, %d %b %Y %H:%M:%S %z")
            end),
        }
    )
)
table.insert(snippets, deb)

return snippets, autosnippets
