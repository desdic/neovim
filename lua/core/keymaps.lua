local setkey = vim.keymap.set

setkey("", "<Leader>w", ":w!<CR>", { silent = true, noremap = true, desc = "Write buffer" })

setkey("v", "<", "<gv", { silent = true, noremap = true, desc = "Align to left" })
setkey("v", ">", ">gv", { silent = true, noremap = true, desc = "Align to right" })

setkey("n", "<Leader>qa", ":qa!<CR>", { silent = true, noremap = true, desc = "Quit" })

setkey("i", "<C-H>", "<C-W>", { silent = true, noremap = true, desc = "Delete word backwards" })

setkey(
    "n",
    "<Leader><space>",
    ":nohlsearch<CR>",
    { noremap = true, silent = false, expr = false, desc = "Remove search" }
)

setkey("n", "<Leader>mo", function()
    require("core.mouse").toggle()
end, { silent = true, noremap = true, desc = "Toggle mouse" })

setkey("n", "Y", "yg$", { silent = true, noremap = true, desc = "yank line" })
setkey("x", "<Leader>p", '"_dP', { silent = true, noremap = true, desc = "paste?" })
setkey({ "n", "v" }, "<Leader>y", '"+y', { silent = true, noremap = true, desc = "yank to clipboard" })
setkey("n", "<Leader>Y", '"+Y', { silent = true, noremap = true, desc = "yank line to clipboard" })

-- The mapping xnoremap p "_dP changes the behavior of p when pasting over selected text
-- which is at the end of a line. That occurs because when text at the end of a line is deleted, the cursor
-- moves back to the last character on the line, and P then pastes before that last character.
setkey({ "n", "v" }, "<Leader>d", '"_d', { silent = true, noremap = true, desc = "delete, don't save in register" })

setkey("n", "n", "nzzzv", { silent = true, noremap = true, desc = "search next and center" })
setkey("n", "N", "Nzzzv", { silent = true, noremap = true, desc = "search prev and center" })
setkey("n", "J", "mzJ`z", { silent = true, noremap = true, desc = "join next line and center" })
setkey("n", "<C-d>", "<C-d>zz", { silent = true, noremap = true, desc = "jump center" })
setkey("n", "<C-u>", "<C-u>zz", { silent = true, noremap = true, desc = "jump center" })

setkey("n", "<Leader>tf", require("core.format").toggle, { desc = "Toggle format on Save" })
setkey("n", "<Leader>pbd", ":PlenaryBustedDirectory. <CR>", { desc = "PlenaryTest" })

setkey("n", "<Leader>sl", ":vsplit<CR>", { silent = true, noremap = true, desc = "Split vertical" })

setkey("n", "<Leader>ne", vim.cmd.Ex, { silent = true, noremap = true, desc = "netrw" })
setkey("n", "Q", "<nop>") -- don't like it

setkey("n", "-", "<c-x>", { silent = true, noremap = true, desc = "decrease number" })
setkey("n", "+", "<c-a>", { silent = true, noremap = true, desc = "increase number" })

-- use blackhole register if we delete empty line by dd
setkey("n", "dd", function()
    if vim.api.nvim_get_current_line():match("^%s*$") then
        return '"_dd'
    end
    return "dd"
end, { expr = true, desc = "Delete line but if empty don't put it in any regiester" })

-- Substitute all the occurrance of the current word
setkey("n", "<Leader>S", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

setkey("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move visual line down" })
setkey("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move visual line up" })

setkey("n", "<Leader>bd", ":bd<CR>", { silent = true, noremap = true, desc = "[B]uffer [D]elete" })
