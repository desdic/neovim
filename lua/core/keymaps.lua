local keymap = vim.keymap.set

keymap("n", "<leader>w", ":w!<CR>", { silent = true, noremap = true, desc = "Write buffer" })

keymap("v", "<", "<gv", { silent = true, noremap = true, desc = "Align to left" })
keymap("v", ">", ">gv", { silent = true, noremap = true, desc = "Align to right" })

keymap("n", "<leader>qa", ":qa!<CR>", { silent = true, noremap = true, desc = "Quit" })

keymap("n", "<leader>mo", function()
    require("core.mouse").toggle()
end, { silent = true, noremap = true, desc = "Toggle mouse" })

keymap("n", "Y", "yg$", { silent = true, noremap = true, desc = "yank line" })
keymap({ "n", "v" }, "<leader>y", '"+y', { silent = true, noremap = true, desc = "yank to clipboard" })
keymap("n", "<leader>Y", '"+Y', { silent = true, noremap = true, desc = "yank line to clipboard" })

-- The mapping xnoremap p "_dP changes the behavior of p when pasting over selected text
-- which is at the end of a line. That occurs because when text at the end of a line is deleted, the cursor
-- moves back to the last character on the line, and P then pastes before that last character.
keymap({ "n", "v" }, "<leader>dp", '"_d', { silent = true, noremap = true, desc = "delete, don't save in register" })

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

keymap("n", "<leader><leader>s", ":vsplit<CR>", { silent = true, noremap = true, desc = "Split vertical" })

keymap("n", "<leader><leader>x", function()
    local wins = vim.api.nvim_tabpage_list_wins(0)
    if #wins > 1 then
        vim.cmd("close")
    else
        vim.cmd("bdelete")
    end
end, { desc = "Close window if in split else delete buffer" })

keymap("n", "<leader>ss", ":%s/\\v", { noremap = true, desc = "Substitute" })
keymap("n", "<leader>S", [[:%s/<C-r><C-w>//g<Left><Left>]], { desc = "Substitute word" })

keymap("n", "-", "<c-x>", { silent = true, noremap = true, desc = "decrease number" })
keymap("n", "+", "<c-a>", { silent = true, noremap = true, desc = "increase number" })

-- use blackhole register if we delete empty line with dd
keymap("n", "dd", function()
    if vim.api.nvim_get_current_line():match("^%s*$") then
        return '"_dd'
    end
    return "dd"
end, { expr = true, desc = "Delete line but if empty don't put it in any regiester" })

keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move visual line down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move visual line up" })

keymap("n", "<leader>bd", ":bd<CR>", { silent = true, noremap = true, desc = "[B]uffer [D]elete" })

keymap("i", "jk", "<ESC>", { desc = "Esc" })

keymap("n", "<C-l>", "<C-w>l", { desc = "Move to window on left" })
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to window on right" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to window above" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to window below" })
keymap("n", "Zz", function()
    require("core.window_zoom").toggle()
end, { desc = "Toggle split" })

keymap("n", "<leader>tsh", ":sp term://zsh", { desc = "Open horizontal terminal" })
keymap("n", "<leader>tsv", ":vsp term://zsh", { desc = "Open vertical terminal" })

keymap("n", "<leader>tit", ":InspectTree<CR>", { desc = "Open treesitter object browser" })

keymap("n", "<leader>cx", "<cmd>!chmod +x %<CR>", { desc = "Make file executable" })
keymap("n", "<leader>mm", "<cmd>make<CR>", { desc = "Run `set makeprg=make`" })

keymap("t", "<esc>", [[<C-\><C-n>]], { noremap = true, buffer = 0, desc = "Esc in terminal" })
keymap("t", "jk", [[<C-\><C-n>]], { noremap = true, buffer = 0, desc = "Esc in terminal" })

keymap("n", "<leader>cc", function()
    require("core.quickfix").toggle()
end, { silent = true, noremap = true, desc = "Toggle quickfix" })

keymap("n", "<leader>ll", "<cmd>Lazy<CR>", { desc = "Run [l]azy" })

keymap("n", "yc", "yy<cmd>normal gcc<CR>p", { desc = "Copy to a comment above" })

keymap("n", "<esc>", "<cmd>nohlsearch<CR>", { desc = "stop highligting search" })

keymap("n", "<M-j>", "<cmd>cnext<CR>", { desc = "quickfix next" })
keymap("n", "<M-k>", "<cmd>cprev<CR>", { desc = "quickfix prev" })

keymap("t", "<esc>", "<C-\\><C-N>", { desc = "esc in terminal" })

keymap("n", "<leader><leader>x", "<cmd>:source %<CR>", { desc = "source current lua file" })

keymap("n", "<leader>go", function()
    require("core.git").open()
end, { silent = true, noremap = true, desc = "[G]it [o]pen line in browser" })

-- keymap({ "n", "t" }, "<c-t>", "<cmd>TermToggle<CR>", { desc = "Toggle term" })
keymap({ "n", "t" }, "<c-t>", function()
    require("core.terminal").toggle()
end, { desc = "Toggle term" })
