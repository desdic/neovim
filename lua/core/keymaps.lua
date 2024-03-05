local keymap = vim.keymap.set

keymap("", "<Leader>w", ":w!<CR>", { silent = true, noremap = true, desc = "Write buffer" })

keymap("v", "<", "<gv", { silent = true, noremap = true, desc = "Align to left" })
keymap("v", ">", ">gv", { silent = true, noremap = true, desc = "Align to right" })

keymap("n", "<Leader>qa", ":qa!<CR>", { silent = true, noremap = true, desc = "Quit" })

keymap("i", "<C-H>", "<C-W>", { silent = true, noremap = true, desc = "Delete word backwards" })

keymap(
    "n",
    "<Leader><space>",
    ":nohlsearch<CR>",
    { noremap = true, silent = false, expr = false, desc = "Remove search" }
)

keymap("n", "<Leader>mo", function()
    require("core.mouse").toggle()
end, { silent = true, noremap = true, desc = "Toggle mouse" })

keymap("n", "Y", "yg$", { silent = true, noremap = true, desc = "yank line" })
keymap("x", "<Leader>p", '"_dP', { silent = true, noremap = true, desc = "paste?" })
keymap({ "n", "v" }, "<Leader>y", '"+y', { silent = true, noremap = true, desc = "yank to clipboard" })
keymap("n", "<Leader>Y", '"+Y', { silent = true, noremap = true, desc = "yank line to clipboard" })

-- The mapping xnoremap p "_dP changes the behavior of p when pasting over selected text
-- which is at the end of a line. That occurs because when text at the end of a line is deleted, the cursor
-- moves back to the last character on the line, and P then pastes before that last character.
keymap({ "n", "v" }, "<Leader>d", '"_d', { silent = true, noremap = true, desc = "delete, don't save in register" })

-- Try to keep current line in center
keymap("n", "n", "nzzzv", { silent = true, noremap = true, desc = "search next and center" })
keymap("n", "N", "Nzzzv", { silent = true, noremap = true, desc = "search prev and center" })
keymap("n", "G", "Gzzzv", { silent = true, noremap = true, desc = "botton + center" })
keymap("n", "<C-o>", "<C-o>zzzv", { silent = true, noremap = true, desc = "last + center" })
keymap("n", "J", "mzJ`z", { silent = true, noremap = true, desc = "join next line and center" })
keymap("n", "<C-d>", "<C-d>zz", { silent = true, noremap = true, desc = "jump center" })
keymap("n", "<C-u>", "<C-u>zz", { silent = true, noremap = true, desc = "jump center" })
keymap("n", "{", "{zzzv", { silent = true, noremap = true, desc = "jump and center" })
keymap("n", "}", "}zzzv", { silent = true, noremap = true, desc = "jump and center" })

keymap("n", "<Leader>pbd", ":PlenaryBustedDirectory. <CR>", { desc = "PlenaryTest" })

keymap("n", "<Leader>sl", ":vsplit<CR>", { silent = true, noremap = true, desc = "Split vertical" })

keymap("n", "<Leader>ne", vim.cmd.Ex, { silent = true, noremap = true, desc = "netrw" })

keymap("n", "Q", ":q", { silent = false, noremap = true, desc = "quit" })
keymap("n", "W", ":w", { silent = false, noremap = true, desc = "write" })

keymap("n", "-", "<c-x>", { silent = true, noremap = true, desc = "decrease number" })
keymap("n", "+", "<c-a>", { silent = true, noremap = true, desc = "increase number" })

-- use blackhole register if we delete empty line by dd
keymap("n", "dd", function()
    if vim.api.nvim_get_current_line():match("^%s*$") then
        return '"_dd'
    end
    return "dd"
end, { expr = true, desc = "Delete line but if empty don't put it in any regiester" })

-- Substitute all the occurrance of the current word
keymap("n", "<Leader>S", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move visual line down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move visual line up" })

keymap("n", "<Leader>bd", ":bd<CR>", { silent = true, noremap = true, desc = "[B]uffer [D]elete" })

keymap("n", "<left>", "<C-w>h", { desc = "Move to window on left" })
keymap("n", "<right>", "<C-w>l", { desc = "Move to window above" })
keymap("n", "<down>", "<Nop>", { desc = "Do nothing" })
keymap("n", "<up>", "<Nop>", { desc = "Do nothing" })

-- Better (v|c|)a objects with quotes
keymap("v", 'a"', '2i"', { desc = "Better object quotes handling" })
keymap("v", "a'", "2i'", { desc = "Better object quotes handling" })
keymap("x", 'a"', '2i"', { desc = "Better object quotes handling" })
keymap("x", "a'", "2i'", { desc = "Better object quotes handling" })
