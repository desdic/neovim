local ls = require("luasnip")
local s = ls.s
local i = ls.i
local t = ls.t
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
local d = ls.dynamic_node
local c = ls.choice_node
-- local sn = ls.snippet_node
-- local rep = require("luasnip.extras").rep
local snippet_from_nodes = ls.sn

local ts_locals = require("nvim-treesitter.locals")
local ts_utils = require("nvim-treesitter.ts_utils")
local get_node_text = vim.treesitter.get_node_text

local snippets, autosnippets = {}, {}

-- Adapted from https://github.com/tjdevries/config_manager/blob/1a93f03dfe254b5332b176ae8ec926e69a5d9805/xdg_config/nvim/lua/tj/snips/ft/go.lua
local function same(index)
    return f(function(args)
        return args[1]
    end, { index })
end

-- TODO: look for variables of same type
-- (var_declaration
--  (var_spec
--   name:(identifier) @varname
--   type:(_) @vartype)) (#eq? @vartype "[4]int32")

vim.treesitter.query.set(
    "go",
    "LuaSnip_Result",
    [[ [
    (method_declaration result: (_) @id)
    (function_declaration result: (_) @id)
    (func_literal result: (_) @id)
  ] ]]
)

local indexed = function(info, value)
    if info then
        info.index = info.index + 1
        return i(info.index, value)
    end
    return t(value)
end

local transform = function(text, info)
    -- print(vim.inspect(text))

    if text:match("^(u?int%d*)$") then
        return indexed(info, "0")
    elseif text:match("^(float%d*)$") then
        return indexed(info, "0.0")
    elseif text == "error" then
        if info then
            info.index = info.index + 1

            if info.func_name and info.err_name then
                return c(info.index, {
                    t(string.format('fmt.Errorf("%s: %%v", %s)', info.func_name, info.err_name)),
                    t(info.err_name),
                    -- Be carefull with wrapping, it makes the error part of the API of the
                    -- function, see https://go.dev/blog/go1.13-errors#whether-to-wrap
                    t(string.format('fmt.Errorf("%s: %%w", %s)', info.func_name, info.err_name)),
                })
            end

            if info.err_name then
                return c(info.index, {
                    t(info.err_name),
                    t(string.format('fmt.Errorf("%%w", %s)', info.err_name)),
                })
            end

            return c(info.index, {
                t("nil"),
                t(string.format('fmt.Errorf("")')),
            })
        end

        return t("err")
    elseif text == "bool" then
        if info then
            info.index = info.index + 1
            return c(info.index, {
                t("false"),
                t("true"),
            })
        end
        return t("false")
    elseif text == "string" then
        return indexed(info, '""')
    elseif string.find(text, "*", 1, true) then
        return indexed(info, "nil")
    end

    return indexed(info, text .. "{}")
end

local handlers = {
    ["parameter_list"] = function(node, info)
        local result = {}

        local count = node:named_child_count()
        for idx = 0, count - 1 do
            table.insert(result, transform(get_node_text(node:named_child(idx), 0), info))
            if idx ~= count - 1 then
                table.insert(result, t({ ", " }))
            end
        end

        return result
    end,

    ["type_identifier"] = function(node, info)
        local text = get_node_text(node, 0)
        return { transform(text, info) }
    end,

    ["qualified_type"] = function(node, info)
        local text = get_node_text(node, 0)
        return { transform(text, info) }
    end,

    ["map_type"] = function(node, info)
        local text = get_node_text(node, 0)
        return { transform(text, info) }
    end,
}

local function go_result_type(info)
    local cursor_node = ts_utils.get_node_at_cursor()
    ---@diagnostic disable-next-line: param-type-mismatch
    local scope = ts_locals.get_scope_tree(cursor_node, 0)

    local function_node
    if scope then
        for _, v in ipairs(scope) do
            if v:type() == "function_declaration" or v:type() == "method_declaration" or v:type() == "func_literal" then
                function_node = v
                break
            end
        end
    end

    if function_node ~= nil then
        local query = vim.treesitter.query.get("go", "LuaSnip_Result")
        if query then
            for _, node in query:iter_captures(function_node, 0) do
                if handlers[node:type()] then
                    return handlers[node:type()](node, info)
                else
                    print("unhandled type '" .. node:type() .. "'")
                end
            end
        end
    end

    -- if there is no return don't return one
end

local go_ret_vals = function(args)
    return snippet_from_nodes(
        nil,
        go_result_type({
            index = 0,
            err_name = (#args > 0 and args[1][1] or nil),
            func_name = (#args > 1 and args[2][1] or nil),
        })
    )
end

local iferrsmart = s("iferr", {
    t({ "if " }),
    i(1, { "err" }),
    t({ " != nil {", "\treturn " }),
    d(2, go_ret_vals, { 1 }),
    t({ "", "}" }),
    i(0),
})

table.insert(snippets, iferrsmart)

local iferrsmartfunc = s("iferrfunc", {
    i(1, { "val" }),
    t(", "),
    i(2, { "err" }),
    t(" := "),
    i(3, { "f" }),
    t("("),
    i(4),
    t(")"),
    t({ "", "if " }),
    same(2),
    t({ " != nil {", "\treturn " }),
    d(5, go_ret_vals, { 2, 3 }),
    t({ "", "}" }),
    i(0),
})

table.insert(snippets, iferrsmartfunc)

local ret = s("ret", {
    t({ "return " }),
    d(1, go_ret_vals, {}),
})

table.insert(snippets, ret)

local main = s(
    { trig = "main", name = "main" },
    fmt(
        [[
package main

func main() {{
{}{}
}}
        ]],
        {

            t({ "\t" }),
            i(0),
        }
    )
)

table.insert(snippets, main)

return snippets, autosnippets
