local ok, harpoon = pcall(require, "harpoon")
if not ok then
    vim.notify("Unable to require harpoon", vim.lsp.log_levels.ERROR, {title = "Plugin error"})
    return
end

local okm, harpoonmark = pcall(require, "harpoon.mark")
if not okm then
    vim.notify("Unable to require harpoon.mark", vim.lsp.log_levels.ERROR, {title = "Plugin error"})
    return
end

local okui, harpoonui = pcall(require, "harpoon.ui")
if not okui then
    vim.notify("Unable to require harpoon.ui", vim.lsp.log_levels.ERROR, {title = "Plugin error"})
    return
end

harpoon.setup()

vim.keymap.set("n", "<Leader>a", function() harpoonmark.add_file() end,
               {noremap = true, silent = true, desc = "Harpoon [a]dd file"})

vim.keymap.set("n", "<Leader>/", function() harpoonui.nav_next() end,
               {noremap = true, silent = true, desc = "Harpoon next"})

vim.keymap.set("n", "<Leader>.", function() harpoonui.nav_prev() end,
               {noremap = true, silent = true, desc = "Harpoon previous"})

for i = 1, 4 do
    vim.keymap.set("n", "<Leader>" .. i, function() harpoonui.nav_file(i) end,
                   {noremap = true, silent = true, desc = "Harpoon file " .. i})
end
