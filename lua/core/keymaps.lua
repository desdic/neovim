vim.keymap.set("", "<Leader>w", ":w!<CR>", { silent = true, noremap = true, desc = "Write buffer" })

vim.keymap.set("v", "<", "<gv", { silent = true, noremap = true, desc = "Align to left" })
vim.keymap.set("v", ">", ">gv", { silent = true, noremap = true, desc = "Align to right" })

vim.keymap.set("n", "<Leader>qa", ":qa!<CR>", { silent = true, noremap = true, desc = "Quit" })

vim.keymap.set("i", "<C-H>", "<C-W>", { silent = true, noremap = true, desc = "Delete word backwards" })

vim.keymap.set(
    "n",
    "<Leader><space>",
    ":nohlsearch<CR>",
    { noremap = true, silent = false, expr = false, desc = "Remove search" }
)

vim.keymap.set(
    "n",
    "<Leader>cm",
    ":delmarks a-zA-Z0-9<CR>",
    { silent = true, noremap = true, desc = "Clear all marks" }
)

vim.keymap.set("n", "<Leader>mo", function()
    require("core.mouse").toggle()
end, { silent = true, noremap = true, desc = "Toggle mouse" })

-- Move to window using the arrow keys
vim.keymap.set("n", "<left>", "<C-w>h", { desc = "Move to window on left" })
vim.keymap.set("n", "<down>", "<C-w>j", { desc = "Move to window on right" })
vim.keymap.set("n", "<up>", "<C-w>k", { desc = "Move to window below" })
vim.keymap.set("n", "<right>", "<C-w>l", { desc = "Move to window above" })

-- Resizing
vim.keymap.set("n", "<S-left>", "<C-w><", { desc = "Resize horizontal right" })
vim.keymap.set("n", "<S-down>", "<C-w>-", { desc = "Resize horizontal left" })
vim.keymap.set("n", "<S-up>", "<C-w>+", { desc = "Resize vertical up" })
vim.keymap.set("n", "<S-right>", "<C-w>>", { desc = "Resize vertical down" })

-- Keymaps for plugins is located with plugin setup

vim.keymap.set("n", "Y", "yg$", { silent = true, noremap = true, desc = "yank line" })
vim.keymap.set("x", "<Leader>p", '"_dP', { silent = true, noremap = true, desc = "paste?" })
vim.keymap.set({ "n", "v" }, "<Leader>y", '"+y', { silent = true, noremap = true, desc = "yank to clipboard" })
vim.keymap.set("n", "<Leader>Y", '"+Y', { silent = true, noremap = true, desc = "yank line to clipboard" })

-- The mapping xnoremap p "_dP changes the behavior of p when pasting over selected text
-- which is at the end of a line. That occurs because when text at the end of a line is deleted, the cursor
-- moves back to the last character on the line, and P then pastes before that last character.
vim.keymap.set(
    { "n", "v" },
    "<Leader>d",
    '"_d',
    { silent = true, noremap = true, desc = "delete, don't save in register" }
)

vim.keymap.set("n", "n", "nzzzv", { silent = true, noremap = true, desc = "search next and center" })
vim.keymap.set("n", "N", "Nzzzv", { silent = true, noremap = true, desc = "search prev and center" })
vim.keymap.set("n", "J", "mzJ`z", { silent = true, noremap = true, desc = "join next line and center" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true, noremap = true, desc = "jump center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true, noremap = true, desc = "jump center" })

vim.keymap.set("n", "<Leader>tf", require("core.format").toggle, { desc = "Toggle format on Save" })
vim.keymap.set("n", "<Leader>pbd", ":PlenaryBustedDirectory. <CR>", { desc = "PlenaryTest" })

vim.keymap.set("n", "<Leader>sl", ":vsplit<CR>", { silent = true, noremap = true, desc = "Split vertical" })

vim.keymap.set("n", "<Leader>ne", vim.cmd.Ex, { silent = true, noremap = true, desc = "netrw" })
vim.keymap.set("n", "Q", "<nop>") -- don't like it

vim.keymap.set("n", "-", "<c-x>", { silent = true, noremap = true, desc = "decrease number" })
vim.keymap.set("n", "+", "<c-a>", { silent = true, noremap = true, desc = "increase number" })

-- use blackhole register if we delete empty line by dd
vim.keymap.set("n", "dd", function()
    if vim.api.nvim_get_current_line():match("^%s*$") then
        return '"_dd'
    else
        return "dd"
    end
end, { expr = true })

-- Substitute all the occurrance of the current word
vim.keymap.set('n', '<Leader>S', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>')
