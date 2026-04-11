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
        vim.hl.on_yank({})
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

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "PlenaryTestPopup",
        "checkhealth",
        "git",
        "gitsigns-blame",
        "greyjoy",
        "help",
        "macrothishelp",
        "man",
        "notify",
        "nvim-pack",
        "nvim-undotree",
        "oil",
        "qf",
        "query",
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

local register_capability = vim.lsp.handlers["client/registerCapability"]
vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then
        return
    end

    require("config.lspkeymaps").on_attach(client, vim.api.nvim_get_current_buf())

    return register_capability(err, res, ctx)
end

-- Attach my keymappins for all LSPs
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end

        require("config.lspkeymaps").on_attach(client, args.buf)
    end,
})

-- Set up LSP servers.
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    once = true,
    callback = function()
        -- Extend neovim's client capabilities with the completion ones.
        vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(nil, true) })

        local servers = vim.iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
            :map(function(file)
                return vim.fn.fnamemodify(file, ":t:r")
            end)
            :totable()
        vim.lsp.enable(servers)
    end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("UserBufConfig", {}),
    callback = function(ev)
        require("core.format").on_attach(ev, ev.buf)
    end,
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

-- Clear jumps
vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("ClearJumps", { clear = true }),
    callback = function()
        vim.cmd.clearjumps()
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.zig", "*.zon" },
    callback = function(_)
        vim.lsp.buf.code_action({
            context = { only = { "source.organizeImports" } },
            apply = true,
        })
    end,
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
        vim.cmd("wincmd =")
    end,
})

vim.api.nvim_create_user_command("Scratch", function()
    vim.cmd("bel new")
    local buf = vim.api.nvim_get_current_buf()
    for name, value in pairs({
        filetype = "scratch",
        buftype = "nofile",
        bufhidden = "wipe",
        swapfile = false,
        modifiable = true,
    }) do
        vim.api.nvim_set_option_value(name, value, { buf = buf })
    end
end, { desc = "Open a scratch buffer", nargs = 0 })

-- Enable treesitter
vim.api.nvim_create_autocmd({ "FileType", "LspAttach" }, {
    group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
    callback = function(event)
        local lang = vim.treesitter.language.get_lang(event.match) or event.match

        if vim.treesitter.query.get(lang, "highlights") then
            vim.treesitter.start()
        end
        if vim.treesitter.query.get(lang, "indents") then
            vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
        end
    end,
})
