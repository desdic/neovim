local lsok, ls = pcall(require, "luasnip")
if not lsok then
    vim.notify("Unable to require luasnip")
    return
end

local lsvsok, lsvscode = pcall(require, "luasnip.loaders.from_vscode")
if not lsvsok then
    vim.notify("Unable to require luasnip.loaders.from_vscode")
    return
end

local lsloadok, lsloader = pcall(require, "luasnip.loaders.from_lua")
if not lsloadok then
    vim.notify("Unable to require luasnip.loaders.from_lua")
    return
end

lsloader.load({paths = "~/.config/nvim/snippets"})

local types = require("luasnip.util.types")

ls.config.set_config({
    -- Keep last snippet to jump around
    history = true,

    -- Enable dynamic snippets
    updateevents = "TextChanged,TextChangedI",

    enable_autosnippets = true,

    ext_opts = {
        -- [types.insertNode] = {active = {virt_text = {{"●", "DiffAdd"}}}},
        [types.choiceNode] = {active = {virt_text = {{"●", "Operator"}}}}
    }
})

-- Extend changelog with debchangelog
ls.filetype_extend("changelog", {"debchangelog"})

lsvscode.lazy_load()

vim.keymap.set("n", "<Leader><Leader>s",
               ":luafile ~/.config/nvim/lua/config/luasnip.lua<CR>",
               {silent = false, desc = "Reload snippets"})

vim.keymap.set({"i", "s"}, "<c-j>", function()
    if ls.expand_or_jumpable() then ls.expand_or_jump() end
end, {silent = true})

vim.keymap.set({"i", "s"}, "<c-k>",
               function() if ls.jumpable(-1) then ls.jump(-1) end end,
               {silent = true})

vim.keymap.set("i", "<c-l>", function()
    if ls.choice_active() then ls.change_choice(1) end
end)
