local gomoveok, gomove = pcall(require, "gomove")
if not gomoveok then
    vim.notify("Unable to require gomove", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

gomove.setup({
    map_defaults = false,
    reindent = true,
    undojoin = true,
    move_past_end_col = false
})

-- Normal Mode Move / Duplicate
vim.keymap.set("n", "<A-S-j>", "<Plug>GoNSMDown", {desc = "move down"})
vim.keymap.set("n", "<A-S-k>", "<Plug>GoNSMUp", {desc = "move up"})
vim.keymap.set("n", "<A-S-h>", "<Plug>GoNSMLeft", {desc = "move left"})
vim.keymap.set("n", "<A-S-l>", "<Plug>GoNSMRight", {desc = "move right"})

-- Visual Mode Move
vim.keymap.set("x", "<A-S-j>", "<Plug>GoVSMDown", {desc = "move down"})
vim.keymap.set("x", "<A-S-k>", "<Plug>GoVSMUp", {desc = "move up"})
vim.keymap.set("x", "<A-S-h>", "<Plug>GoVSMLeft", {desc = "move left"})
vim.keymap.set("x", "<A-S-l>", "<Plug>GoVSMRight", {desc = "move right"})
