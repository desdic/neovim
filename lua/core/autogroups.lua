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
        "oil",
        "qf",
        "query",
        "startuptime",
        "tsplayground",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Close buffer" })
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

vim.api.nvim_create_autocmd("VimLeave", {
    group = vim.api.nvim_create_augroup("RestoreCursorShapeOnExit", { clear = true }),
    callback = function()
        vim.opt.guicursor = "a:block1"
    end,
    nested = true,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    group = vim.api.nvim_create_augroup("FormatOptions", { clear = true }),
    pattern = { "*" },
    callback = function()
        -- :h fo-table
        -- Disable autowrap and comments continued on new lines
        vim.opt_local.fo:remove("c")
        vim.opt_local.fo:remove("r")
        vim.opt_local.fo:remove("o")
        vim.opt_local.fo:remove("t")
    end,
})

local hassnacks, _ = pcall(require, "snacks")
if hassnacks then
    local progress = vim.defaulttable()
    vim.api.nvim_create_autocmd("LspProgress", {
        ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
        callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
            if not client or type(value) ~= "table" then
                return
            end

            local p = progress[client.id]

            for i = 1, #p + 1 do
                if i == #p + 1 or p[i].token == ev.data.params.token then
                    p[i] = {
                        token = ev.data.params.token,
                        msg = ("[%3d%%] %s%s"):format(
                            value.kind == "end" and 100 or value.percentage or 100,
                            value.title or "",
                            value.message and (" **%s**"):format(value.message) or ""
                        ),
                        done = value.kind == "end",
                    }
                    break
                end
            end

            local msg = {} ---@type string[]
            progress[client.id] = vim.tbl_filter(function(v)
                return table.insert(msg, v.msg) or not v.done
            end, p)

            local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
            vim.notify(table.concat(msg, "\n"), "info", {
                id = "lsp_progress",
                title = client.name,
                opts = function(notif)
                    notif.icon = #progress[client.id] == 0 and " "
                        or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
                end,
            })
        end,
    })
end
