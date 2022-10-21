local ok, harpoon = pcall(require, "harpoon")
if not ok then
    vim.notify("Unable to require harpoon", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

local okm, harpoonmark = pcall(require, "harpoon.mark")
if not okm then
    vim.notify("Unable to require harpoon.mark", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

local okui, harpoonui = pcall(require, "harpoon.ui")
if not okui then
    vim.notify("Unable to require harpoon.ui", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

harpoon.setup()

vim.keymap.set("n", "<Leader>a", function() harpoonmark.add_file() end,
               {noremap = true, silent = true, desc = "Add file"})

vim.keymap.set("n", "<Leader>hf", function() harpoonui.nav_next() end,
               {noremap = true, silent = true, desc = "Next file"})

vim.keymap.set("n", "<Leader>hd", function() harpoonui.nav_prev() end,
               {noremap = true, silent = true, desc = "Prev file"})

for i = 1, 9 do
    vim.keymap.set("n", "<Leader>" .. i, function() harpoonui.nav_file(i) end,
                   {noremap = true, silent = true, desc = "Navigate to file"})
end

vim.keymap.set("n", "<Leader>.", function() harpoonui.nav_file(1) end,
               {noremap = true, silent = true, desc = "Navigate to file"})

vim.keymap.set("n", "<Leader>/", function() harpoonui.nav_file(2) end,
               {noremap = true, silent = true, desc = "Navigate to file"})
