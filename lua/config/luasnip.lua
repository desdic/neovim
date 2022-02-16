local lsok, ls = pcall(require, "luasnip")
if not lsok then
    vim.notify("Unable to require luasnip")
    return
end

local s = ls.s
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local types = require("luasnip.util.types")
-- local t = ls.text_node
-- local c = ls.choice_node
-- local rep = require("luasnip.extras").rep

ls.config.set_config({
    -- Keep last snippet to jump around
    history = true,

    -- Enable dynamic snippets
    updateevents = "TextChanged,TextChangedI",

    enable_autosnippets = true,

    ext_opts = {
        [types.choiceNode] = {
            active = {virt_text = {{"<--", "Error"}}}
        }
    }
})

local date_input = function(_, _, old_state, format)
  if not old_state then
    old_state = {}
  end

  local cfmt = format or '%Y-%m-%d'
  return sn(nil, i(1, os.date(cfmt)))
end

ls.snippets = {
    all = {
        ls.parser.parse_snippet("$file$", "$TM_FILENAME"),
    },

    lua = {},

    python = {
        s("main", fmt('if __name__ == "__main__":\n\t{}', i(0, "main()"))),
        s("#!", fmt("#!/usr/bin/env {}", i(0, "python3"))),
        s("def", fmt("def {}({}) -> {}:\n\t{}\n",
                     {i(1, "name"), i(2), i(3, "None"), i(0, "pass")}))
    },

    debchangelog = {
        s("cl",
          fmt(
              "{} ({}) {}; urgency={}\n\n  * {}\n\n -- Kim Nielsen <{}@{}.{}> {}\n\n",
              {
                i(1, "mypackage"), i(2, "0"), i(3, "systems-focal"),
                i(4, "medium"), i(5, "<message>"), i(6, "kgn"), i(7, "one"),
                i(8, "com"), d(9, date_input, {}, "%a, %d, %b %Y %H:%M:%S %z")
            }))
    }
}

require("luasnip.loaders.from_vscode").lazy_load()

local keymap = vim.api.nvim_set_keymap

keymap("n", "<Leader><Leader>s",
       "<cmd>source ~/.config/nvim/lua/config/luasnip.lua<CR>", {silent = false})
