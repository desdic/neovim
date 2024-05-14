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
local utils = require("core.utils")

local snippets, autosnippets = {}, {}

local def = s(
    { trig = "def", name = "definition" },
    fmt(
        [[def {}({}) -> {}:
    {}
        ]],
        {
            i(1, "name"),
            i(2),
            i(3, "None"),
            i(0, 'raise NotImplementedError("To be implemented")'),
        }
    )
)
table.insert(snippets, def)

local top_and_python = function()
    local ftype = vim.bo.filetype
    if ftype ~= "python" then
        return false
    end

    local is_top = utils.is_top_empty_file()
    if not is_top then
        return false
    end

    return true
end

local boilerplate_python = function(position)
    return d(position, function()
        local nodes = { t("python3"), t("python") }
        return sn(nil, {
            t("#!/usr/bin/env "),
            c(1, nodes),
            t({ "", "", "" }),
            t({ [[import argparse]], [[import logging]] }),
            t({ "", "", "" }),
            t("logger = logging.getLogger(__name__)"),
            t({ "", "" }),
            t({ "", "", "" }),
            t({
                [[def main():]],
                [[    arg_parser = argparse.ArgumentParser()]],
                [[    arg_parser.add_argument("--debug", "-d", action="store_true", help="enable debug")]],
                [[    args = arg_parser.parse_args()]],
                [[]],
                [[    logging.basicConfig(level=logging.DEBUG if args.debug else logging.INFO)]],
            }),
            t({ "", "", "" }),
            t({ "    " }),
            i(2),
            t({ "", "", "" }),
            t([[if __name__ == "__main__":]]),
            t({ "", "" }),
            t([[    main()]]),
        })
    end, {})
end

local empty = s({ trig = "boilerplate" }, boilerplate_python(1), { condition = top_and_python() })
table.insert(snippets, empty)

return snippets, autosnippets
