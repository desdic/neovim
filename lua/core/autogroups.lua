-- No share or backup files in /mnt or /boot
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "/mnt/*", "/boot/*" },
    callback = function()
        vim.opt_local.undofile = true
        vim.opt_local.shada = "NONE"
    end,
})

-- Show yanking for 200ms
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    callback = function()
        vim.highlight.on_yank({
            on_visual = false,
            higroup = "IncSearch",
            timeout = 200,
        })
    end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, { command = "checktime" })

local is_lazy_open = function()
    local buffers = vim.api.nvim_list_bufs()
    for _, buf in ipairs(buffers) do
        local filetype = vim.bo[buf].filetype

        if filetype == "lazy" then
            return true
        end
        if filetype == "lazy_backdrop" then
            return true
        end
    end
    return false
end

vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("restore_marlin", { clear = true }),
    callback = function()
        if next(vim.fn.argv()) ~= nil then
            return
        end
        if not is_lazy_open() then
            require("marlin").open_all()
        end
    end,
    nested = true,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        -- :h fo-table (default tcqj)
        vim.opt.formatoptions:remove({ "c", "r", "o" })
        vim.opt.formatoptions:append({ "n" })
    end,
    desc = "Disable New Line Comment",
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "PlenaryTestPopup",
        "checkhealth",
        "fugitive",
        "fugitiveblame",
        "git",
        "greyjoy",
        "help",
        "lazy",
        "lspinfo",
        "macrothishelp",
        "man",
        "notify",
        "qf",
        "query",
        "startuptime",
        "tsplayground",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "<esc>", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Close buffer" })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "DiffviewFiles",
        "DiffviewFileHistory",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>DiffviewClose<cr>", { buffer = event.buf, silent = true, desc = "Close buffer" })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "qf",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set(
            "n",
            "o",
            "<cmd>silent! cfdo edit %<cr>",
            { buffer = event.buf, silent = true, desc = "Edit all in quickfix list" }
        )
        vim.keymap.set("n", "r", function()
            return ":cdo s///gc<Left><Left><Left><Left>"
        end, { silent = false, expr = true, noremap = true, desc = "Search and replace all in quickfix list" })
    end,
})

-- Attach my keymappins for all LSPs
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = require("core.lspkeymaps").setkeys,
})

-- Create a local buffer keymap for fzf buffers to map esc to Ctrl-c
vim.api.nvim_create_autocmd("FileType", {
    pattern = "fzf",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, "t", "<esc>", "<c-c>", { noremap = true, silent = true })
    end,
})
