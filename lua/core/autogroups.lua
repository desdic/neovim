local autogroups = {
    ["_general"] = {
        [{ "WinEnter", "TabEnter", "FocusGained" }] = { [{ "*" }] = { "checktime" } },
        [{ "BufEnter" }] = { [{ "*" }] = { "set formatoptions-=cro" } },
        [{ "BufWritePre" }] = {
            [{ "/mnt/*", "/boot/*" }] = {
                'setlocal noundofile,setlocal shada="NONE"',
            },
        },
    },
    ["_text"] = {
        [{ "FileType" }] = {
            [{ "text", "txt" }] = {
                "set tw=80 fo+=taw spell",
                "set noexpandtab",
                "set tabstop=4",
                "set shiftwidth=4",
            },
        },
    },
    ["_mail"] = { [{ "FileType" }] = { [{ "mail" }] = { "set tw=72 fo+=taw spell" } } },
    ["_gitcommit"] = { [{ "FileType" }] = { [{ "gitcommit" }] = { "set spell" } } },
    ["_help"] = { [{ "FileType" }] = { [{ "help" }] = { "setlocal nolist" } } },
    ["_ruby"] = {
        [{ "FileType" }] = {
            [{ "ruby", "eruby", "ruby.eruby.chef" }] = {
                "set expandtab",
                "set shiftwidth=2",
                "set softtabstop=2",
                "set tabstop=2",
            },
        },
    },
}

for autogrp, autovalues in pairs(autogroups) do
    for autotypes, autosettings in pairs(autovalues) do
        local augroup = vim.api.nvim_create_augroup(autogrp, { clear = true })

        for typelist, commands in pairs(autosettings) do
            for _, command in ipairs(commands) do
                vim.api.nvim_create_autocmd(autotypes, {
                    pattern = typelist,
                    command = command,
                    group = augroup,
                })
            end
        end
    end
end

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
        "qf",
        "help",
        "man",
        "notify",
        "lspinfo",
        "startuptime",
        "tsplayground",
        "PlenaryTestPopup",
        "macrothishelp",
        "greyjoy",
        "fugitive",
        "fugitiveblame",
        "git",
        "checkhealth",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Close buffer" })
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
