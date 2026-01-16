local keymap = vim.keymap.set
keymap("n", "k", function()
    return vim.v.count == 0 and "gk" or "k"
end, { expr = true, noremap = true })

keymap("n", "j", function()
    return vim.v.count == 0 and "gj" or "j"
end, { expr = true, noremap = true })

keymap("n", "<leader>w", ":w!<CR>", { silent = true, noremap = true, desc = "Write buffer" })

keymap("v", "<", "<gv", { silent = true, noremap = true, desc = "Align to left" })
keymap("v", ">", ">gv", { silent = true, noremap = true, desc = "Align to right" })

keymap("n", "<leader>mo", function()
    require("core.mouse").toggle()
end, { silent = true, noremap = true, desc = "Toggle mouse" })

keymap("n", "Y", "yg$", { silent = true, noremap = true, desc = "yank line" })
keymap({ "n", "v" }, "<leader>y", '"+y', { silent = true, noremap = true, desc = "yank to clipboard" })

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

keymap("n", "<leader>su", ":%s/\\v", { noremap = true, desc = "[S][u]bstitute" })
keymap("n", "<leader>sw", [[:%s/<C-r><C-w>//g<Left><Left>]], { desc = "[S]ubstitute [w]ord" })

-- use blackhole register if we delete empty line with dd
keymap("n", "dd", function()
    if vim.api.nvim_get_current_line():match("^%s*$") then
        return '"_dd'
    end
    return "dd"
end, { expr = true, desc = "Delete line but if empty don't put it in any regiester" })

keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move visual line down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move visual line up" })

keymap("t", "<C-h>", [[<C-\><C-N><C-w>h]], { desc = "Move to split on the left" })
keymap("t", "<C-j>", [[<C-\><C-N><C-w>j]], { desc = "Move to split below" })
keymap("t", "<C-k>", [[<C-\><C-N><C-w>k]], { desc = "Move to split above" })
keymap("t", "<C-l>", [[<C-\><C-N><C-w>l]], { desc = "Move to split on the right" })

-- Ctrl+\Ctrl+n to exit insert mode in terminal
keymap("t", "<C-q>", [[<C-\><C-N>]], { desc = "ESC" })

keymap("n", "<leader>tit", ":InspectTree<CR>", { desc = "Open treesitter object browser" })

keymap("n", "<leader>cx", "<cmd>!chmod +x %<CR>", { desc = "Make file executable" })
keymap("n", "<leader>mm", "<cmd>make<CR>", { desc = "Run `set makeprg=make`" })

keymap("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "Run [L]azy" })

keymap("n", "yc", "yy<cmd>normal gcc<CR>p", { desc = "Copy to a comment above" })

keymap({ "i", "s", "n" }, "<esc>", function()
    if require("luasnip").expand_or_jumpable() then
        require("luasnip").unlink_current()
    end
    vim.cmd("noh")
    return "<esc>"
end, { desc = "Escape, clear hlsearch, and stop snippet session", expr = true })

keymap("n", "U", "<C-r>", { desc = "Redo" })

keymap("n", "j", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'j']], { expr = true })
keymap("n", "k", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'k']], { expr = true })

keymap("n", "<M-j>", "<cmd>cnext<CR>", { desc = "quickfix next" })
keymap("n", "<M-k>", "<cmd>cprev<CR>", { desc = "quickfix prev" })

keymap("n", "<leader>sf", "<cmd>:source %<CR>", { desc = "source current lua file" })

keymap("n", "<leader>st", function()
    vim.opt.spell = not (vim.opt.spell:get())
end, { desc = "[S]pell [t]oggle" })

keymap("n", "<leader>tf", require("core.format").toggle, { desc = "Toggle format on Save" })
keymap({ "n", "v" }, "<leader>fm", require("core.format").format, { desc = "[F]or[m]at Document" })

keymap("n", "U", "<C-r>", { desc = "Redo" })

-- Quickly go to the end of the line while in insert mode.
keymap({ "i", "c" }, "<C-l>", "<C-o>A", { desc = "Go to the end of the line" })

-- Easy surround selections
keymap("x", '"', 'c"<C-r>""<Esc>')
keymap("x", "'", "c'<C-r>\"'<Esc>")
keymap("x", "(", 'c(<C-r>")<Esc>')
keymap("x", "{", 'c{<C-r>"}<Esc>')
keymap("x", "`", 'c`<C-r>"`<Esc>')

keymap("n", "Q", "<cmd>q<CR>")
