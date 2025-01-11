local ls = require("luasnip")
local s = ls.s
local i = ls.i
local t = ls.t
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

local snippets, autosnippets = {}, {}

local main = s(
    { trig = "main", name = "main" },
    fmt(
        [[
#!/usr/bin/env {}

import argparse
import logging

logger = logging.getLogger(__name__)

def main() -> None:
{}arg_parser = argparse.ArgumentParser()
{}arg_parser.add_argument("--debug", "-d", action="store_true", help="enable debug")
{}args = arg_parser.parse_args()

{}logging.basicConfig(level=logging.DEBUG if args.debug else logging.INFO)
{}{}

if __name__ == "__main__":
{}main()
        ]],
        {
            c(1, { t("python3"), t("python") }),
            t({ "\t" }),
            t({ "\t" }),
            t({ "\t" }),
            t({ "\t" }),
            t({ "\t" }),
            i(0),
            t({ "\t" }),
        }
    )
)

table.insert(snippets, main)

return snippets, autosnippets
