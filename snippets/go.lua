local ls = require("luasnip")
local s = ls.s
local i = ls.i
local t = ls.t
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local d = ls.dynamic_node
local c = ls.choice_node
local sn = ls.snippet_node
local rep = require("luasnip.extras").rep
local snippet_from_nodes = ls.sn
local corets = require("core.treesitter")

local snippets, autosnippets = {}, {}

local iferrnil = s(
    { trig = "ifn", name = "if err != nil" },
    fmt(
        [[if err != nil {{
	{}
}}
		]],
        { i(1, "name") }
    )
)
table.insert(snippets, iferrnil)

local ifshort = s(
    { trig = "ifns", name = "short if not nil" },
    fmt(
        [[if err := {}; err != nil {{
	{}
}}
		]],
        { i(1, "name"), i(2, "") }
    )
)
table.insert(snippets, ifshort)

-- The return Go bases snipped is based of TJ's TakeTuesday E04
local M = {}

M.transformations = {
    int = function(_, info)
        return i(info.index, "0")
    end,

    bool = function(_, info)
        return i(info.index, "false")
    end,

    string = function(_, info)
        return i(info.index, [[""]])
    end,

    error = function(_, info)
        if info and info.err_name ~= nil then
            return c(info.index, {
                t(info.err_name),
                t(string.format('errors.Wrap(%s, "%s")', info.err_name, info.func_name)),
            })
        end

        return i(info.index, "nil")
    end,

    -- Types with a "*" mean they are pointers, so return nil
    [function(text)
        return string.find(text, "*", 1, true) ~= nil
    end] = function(_, info)
        return i(info.index, "nil")
    end,
}

M.get_return_type = function(args)
    local query = [[
      [
        (method_declaration result: (_) @id)
        (function_declaration result: (_) @id)
        (func_literal result: (_) @id)
      ]
    ]]

    local err_name = nil
    local func_name = nil
    if type(args) == "table" and type(args[1]) == "table" then
        err_name = args[1][1]
        func_name = args[1][2]
    end

    local index = 0
    local ret = corets.process_query_result(query, "go", corets.go_handlers, corets.go_function_node_types)
    if #ret ~= 0 then
        local result = { t(" ") }
        for idx, x in pairs(ret) do
            index = index + 1
            table.insert(
                result,
                corets.transform(x, { index = index, err_name = err_name, func_name = func_name }, M.transformations)
            )

            if idx ~= #ret then
                table.insert(result, t(", "))
            end
        end
        return snippet_from_nodes(nil, result)
    end

    -- Indicate we failed to handle this type
    return snippet_from_nodes(nil, {})
end

local ret = s(
    { trig = "ret", name = "return" },
    fmta(
        [[
return<result>
]],
        {
            result = d(1, M.get_return_type, {}),
        }
    )
)

table.insert(snippets, ret)

local efi = s(
    { trig = "efi", name = "iferr" },
    fmta(
        [[
<val>, <err> := <f>(<args>)
if <err_same> != nil {
	return<result>
}
<finish>
]],
        {
            val = i(1),
            err = i(2, "err"),
            f = i(3),
            args = i(4),
            err_same = rep(2),
            result = d(5, M.get_return_type, { 2, 3 }),
            finish = i(0),
        }
    )
)

table.insert(snippets, efi)

return snippets, autosnippets
