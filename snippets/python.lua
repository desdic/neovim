local ls = require("luasnip")
local s = ls.s
local i = ls.i
local t = ls.t
local fmt = require("luasnip.extras.fmt").fmt
local d = ls.dynamic_node
local c = ls.choice_node
-- local f = ls.function_node
local sn = ls.snippet_node
-- local rep = require("luasnip.extras").rep

local snippets, autosnippets = {}, {}

local def = s({trig = "def", name = "definition"}, fmt(
                  [[def {}({}) -> {}:
    {}
        ]], {
        i(1, "name"), i(2), i(3, "None"),
        i(0, 'raise NotImplementedError("To be implemented")')
    }))
table.insert(snippets, def)

local is_top_empty_file = function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local _, col = vim.api.nvim_win_get_cursor(0)
    if #lines <= 1 and col == 2 then return true end
    return false
end

local empty_python = function(position)
    return d(position, function()
        local nodes = {t("python3"), t("python")}
        return sn(nil, {
            c(1, {t("#!/usr/bin/env "), t("#!/sbin/env ")}), c(2, nodes),
            t({"", "", ""}), t({[[import argparse]], [[import logging]]}),
            t({"", "", ""}), t("logger = logging.getLogger(__name__)"),
            t({"", ""}), t({"", "", ""}), t({
                [[def main():]], [[    arg_parser = argparse.ArgumentParser()]],
                [[    arg_parser.add_argument("--debug", "-d", action="store_true", help="enable debug")]],
                [[    args = arg_parser.parse_args()]], [[]],
                [[    logging.basicConfig(level=logging.DEBUG if args.debug else logging.INFO)]]
            }), t({"", "", ""}), t({"    "}), i(3), t({"", "", ""}),
            t([[if __name__ == "__main__":]]), t({"", ""}), t([[    main()]])
        })
    end, {})
end

local empty = s({trig = "#!"}, empty_python(1),
                {condition = is_top_empty_file()})
table.insert(autosnippets, empty)

return snippets, autosnippets
