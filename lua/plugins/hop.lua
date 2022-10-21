local lsok, hop = pcall(require, "hop")
if not lsok then
    vim.notify("Unable to require hop")
    return
end

local hintok, hint = pcall(require, "hop.hint")
if not hintok then
    vim.notify("Unable to require hop.hint")
    return
end

hop.setup()

vim.keymap.set("n", "s", function() hop.hint_char1() end,
               {desc = "Jump to char"})

vim.keymap.set("o", "s", function() hop.hint_char1({inclusive_jump = true}) end,
               {desc = "Jump to char"})

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

vim.keymap.set("", "f", function()
    hop.hint_char1({
        direction = hint.HintDirection.AFTER_CURSOR,
        current_line_only = true
    })
end, {desc = "Jump forward to char"})

vim.keymap.set("", "F", function()
    hop.hint_char1({
        direction = hint.HintDirection.BEFORE_CURSOR,
        current_line_only = true
    })
end, {desc = "Jump back to char"})

vim.keymap.set("", "t", function()
    hop.hint_char1({
        direction = hint.HintDirection.AFTER_CURSOR,
        current_line_only = true,
        hint_offset = -1
    })
end, {desc = "Jump forward -1"})

vim.keymap.set("", "T", function()
    hop.hint_char1({
        direction = hint.HintDirection.BEFORE_CURSOR,
        current_line_only = true,
        hint_offset = -1
    })
end, {desc = "Jump back -1"})
