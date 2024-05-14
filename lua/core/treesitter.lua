local M = {}

local ts_utils = require("nvim-treesitter.ts_utils")
local get_node_text = vim.treesitter.get_node_text

local function getmethod(expr, function_node_types)
    if not expr then
        return nil
    end

    while expr do
        if function_node_types[expr:type()] then
            return expr
        end

        expr = expr:parent()
    end

    return nil
end

M.go_handlers = {
    parameter_list = function(node)
        local result = {}

        local count = node:named_child_count()
        for idx = 0, count - 1 do
            local matching_node = node:named_child(idx)
            local type_node = matching_node:field("type")[1]
            table.insert(result, get_node_text(type_node, 0))
        end
        return result
    end,

    type_identifier = function(node)
        local text = get_node_text(node, 0)
        return { text }
    end,

    pointer_type = function(node)
        local text = get_node_text(node, 0)
        return { text }
    end,
}

M.go_function_node_types = {
    function_declaration = true,
    method_declaration = true,
    func_literal = true,
}

M.transform = function(text, info, transforms)
    local condition_matches = function(condition, ...)
        if type(condition) == "string" then
            return condition == text
        else
            return condition(...)
        end
    end

    for condition, result in pairs(transforms) do
        if condition_matches(condition, text, info) then
            return result(text, info)
        end
    end

    return t(text)
end

M.process_query_result = function(query, lang, handlers, function_node_types)
    local cursor_node = ts_utils.get_node_at_cursor()
    local function_node = getmethod(cursor_node, function_node_types)
    if function_node == nil then
        return {}
    end

    local tsquery = vim.treesitter.query.parse(lang, query)
    for _, node, _ in tsquery:iter_captures(function_node, 0) do
        if handlers[node:type()] then
            return handlers[node:type()](node)
        end
    end
    return {}
end

return M
