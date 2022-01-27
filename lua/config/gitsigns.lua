local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
    vim.notify("Unable to require gitsigns", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

gitsigns.setup({
    signs = {
        add = {
            hl = "GitSignsAdd",
            text = "│",
            numhl = "GitSignsAddNr",
            linehl = "GitSignsAddLn"
        },
        change = {
            hl = "GitSignsChange",
            text = "│",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn"
        },
        delete = {
            hl = "GitSignsDelete",
            text = "_",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn"
        },
        topdelete = {
            hl = "GitSignsDelete",
            text = "‾",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn"
        },
        changedelete = {
            hl = "GitSignsChange",
            text = "~",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn"
        }
    },
    on_attach = function(bufnr)
        local function map(mode, lhs, rhs, opts)
            opts = vim.tbl_extend("force", {noremap = true, silent = true},
                                  opts or {})
            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
        end

        -- Navigation
        map("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'",
            {expr = true})
        map("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'",
            {expr = true})

        -- Actions
        map("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<CR>")
        map("v", "<leader>hs", "<cmd>Gitsigns stage_hunk<CR>")
        map("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>")
        map("v", "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>")
        map("n", "<leader>hS", "<cmd>Gitsigns stage_buffer<CR>")
        map("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>")
        map("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<CR>")
        map("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>")
        map("n", "<leader>hb",
            '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
        map("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<CR>")
        map("n", "<leader>hd", "<cmd>Gitsigns diffthis<CR>")
        map("n", "<leader>hD", '<cmd>lua require"gitsigns".diffthis("~")<CR>')
        map("n", "<leader>td", "<cmd>Gitsigns toggle_deleted<CR>")

        -- Text object
        map("o", "ih", ":<C-U>Gitsigns select_hunk<CR>")
        map("x", "ih", ":<C-U>Gitsigns select_hunk<CR>")
    end
})
