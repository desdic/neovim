local gomoveok, gomove = pcall(require, "gomove")
if not gomoveok then
    vim.notify("Unable to require gomove", vim.lsp.log_levels.ERROR, {title = "Plugin error"})
    return
end

gomove.setup({map_defaults = false, reindent = true, undojoin = true, move_past_end_col = false})

-- Visual Mode Move
vim.keymap.set("x", "<S-j>", "<Plug>GoVSMDown", {desc = "Move visual line down"})
vim.keymap.set("x", "<S-k>", "<Plug>GoVSMUp", {desc = "Move visual line up"})
vim.keymap.set("x", "<S-h>", "<Plug>GoVSMLeft", {desc = "Move visual line left"})
vim.keymap.set("x", "<S-l>", "<Plug>GoVSMRight", {desc = "Move visual line right"})
