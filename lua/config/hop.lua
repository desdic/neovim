local lsok, hop = pcall(require, "hop")
if not lsok then
    vim.notify("Unable to require hop")
    return
end

hop.setup()

vim.keymap.set("n", "s", function() hop.hint_char1() end,
               {desc = "Jump to char"})

vim.keymap.set("n", "F", function() hop.hint_words() end,
               {desc = "Jump to word"})

vim.keymap.set("o", "s", function() hop.hint_char1({inclusive_jump = true}) end,
               {desc = "Jump to char"})

vim.keymap.set("o", "F", function() hop.hint_words({inclusive_jump = true}) end,
               {desc = "Jump to word"})

vim.keymap.set("v", "s", function() hop.hint_words({inclusive_jump = true}) end,
               {desc = "Jump to word"})

vim.keymap.set("n", "<Leader>hl", function() hop.hint_lines() end,
               {desc = "Jump to line"})

vim.keymap.set("n", "vo", function()
    hop.hint_lines_skip_whitespace()
    vim.schedule(function()
        vim.cmd([[normal! o]])
        vim.cmd([[startinsert]])
    end)
end, {desc = "Jump to line and go into insert mode"})
