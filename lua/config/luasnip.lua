local lsok, ls = pcall(require, "luasnip")
if not lsok then
    vim.notify("Unable to require luasnip")
    return
end

local s = ls.s
local i = ls.insert_node
local d = ls.dynamic_node
local t = ls.text_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local types = require("luasnip.util.types")
local r = require("luasnip.extras").rep
local c = ls.choice_node
local f = ls.function_node

ls.config.set_config({
    -- Keep last snippet to jump around
    history = true,

    -- Enable dynamic snippets
    updateevents = "TextChanged,TextChangedI",

    enable_autosnippets = false,

    ext_opts = {
        -- [types.insertNode] = {active = {virt_text = {{"●", "DiffAdd"}}}},
        [types.choiceNode] = {
            active = {virt_text = {{"<-- choice", "Operator"}}}
        }
    }
})

local file_begin = function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    return row == 1 and col == 1
end

local upper_filename = function()
    -- Uppercase current filename and wrap in underscope
    local filename = "__" .. string.upper(vim.fn.expand("%"):gsub("%.", "_")) ..
                         "__"
    return sn(nil, i(1, filename))
end

local get_debchangelog = function(position)
    return d(position, function()
        local ret = {
            i(1, "mypackage"), t(" ("), i(2, "1"),
            t(") systems-focal; urgency=medium")
        }

        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        for index = #lines, 1, -1 do
            for dname, dversion, dpart in
                string.gmatch(lines[index], "([%w%p]+)%s%((%d+)%)%s(.+)") do
                ret = {i(1, dname), t(" (" .. dversion + 1 .. ") " .. dpart)}
            end
        end
        return sn(nil, ret)
    end, {})
end

local get_file_type = function(position)
    return d(position, function()
        local ftype = vim.bo.filetype
        local nodes = {}
        if ftype == "python" then table.insert(nodes, t("python3")) end
        table.insert(nodes, t(ftype))
        return sn(nil, {
            c(1, {t("#!/usr/bin/env "), t("#!/sbin/env ")}), c(2, nodes),
            t({"", "", ""}), i(3, "")
        })
    end, {})
end

ls.add_snippets("all", {
    ls.parser.parse_snippet("$file$", "$TM_FILENAME"),
    s("#!", get_file_type(1),
      {condition = file_begin, show_condition = file_begin})
})

ls.add_snippets("python", {
    s("def", fmt([[def {}({}) -> {}:
	{}
		]], {i(1, "name"), i(2), i(3, "None"), i(0, "raise NotImplementedError(\"To be implemented\")")}))
})

ls.add_snippets("cpp", {
    s({trig = "#ifndef", name = "header guard"}, fmt([[
#ifndef {}
#define {}

{}

#endif
		]], {d(1, upper_filename, {}), r(1), i(0)}))
})

ls.add_snippets("debchangelog", {
    s({trig = "cl", name = "debian changelog"}, fmt([[
{}

  * {}

 -- {} <{}>  {}

			]], {
        get_debchangelog(1), i(2, "<change>"),
        f(function() return os.getenv("DEBFULLNAME") end),
        f(function() return os.getenv("DEBEMAIL") end),
        f(function() return os.date("%a, %d %b %Y %H:%M:%S %z") end)
    }))
})

-- Extend changelog with debchangelog
ls.filetype_extend("changelog", {"debchangelog"})

require("luasnip.loaders.from_vscode").lazy_load()

vim.keymap.set("n", "<Leader><Leader>s",
       ":luafile ~/.config/nvim/lua/config/luasnip.lua<CR>", {silent = false})

-- TODO not working
vim.keymap.set("i", "<c-k>", function()
	ls.expand()
end, {})
