-- No shada or backup files in /mnt or /boot
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "/mnt/*", "/boot/*" },
    callback = function()
        vim.opt_local.undofile = true
        vim.opt_local.shada = "NONE"
    end,
})

-- Highlight on yank
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

-- Auto imports in zig
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

local group = vim.api.nvim_create_augroup("StatuslineFix", { clear = true })
local function safe_redraw(buf)
    local success, ft = pcall(vim.api.nvim_get_option_value, "filetype", { buf = buf })
    if not success or ft == "snacks_picker_input" then
        return
    end

    local mode = vim.api.nvim_get_mode().mode

    -- Do not redraw if we are actively typing (Insert/Command)
    -- This prevents the "cursor bounce" in pickers and command line.
    if mode == "i" or mode == "c" or mode == "ic" then
        return
    end

    vim.cmd("redrawstatus!")
end

vim.api.nvim_create_autocmd("ModeChanged", {
    group = group,
    -- Pattern: Any mode TO Visual (v), Visual Line (V), or Visual Block (\22)
    pattern = "*:[vV\22]*",
    callback = function()
        if vim.bo.filetype:find("snacks_picker") then
            return
        end

        vim.cmd("redrawstatus")
    end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "VimResized", "LspProgress" }, {
    group = group,
    pattern = "*",
    callback = function(args)
        safe_redraw(args.buf)
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "MarlinPost",
    group = group,
    callback = function(args)
        safe_redraw(args.buf)
    end,
})

vim.api.nvim_create_user_command("SaveMacro", function(params)
    local name = params.args
    local dir = vim.fn.expand("~/.config/nvim/macros/")
    local file = dir .. name .. ".macro"
    local content = vim.fn.getreg("q")

    vim.fn.mkdir(dir, "p")

    vim.fn.writefile({ content }, file, "a")
end, { nargs = 1 })

vim.api.nvim_create_user_command("LoadMacro", function(params)
    local name = params.args
    local dir = vim.fn.expand("~/.config/nvim/macros/")
    local file = dir .. name .. ".macro"

    local content = vim.fn.readfile(file)

    vim.fn.setreg("q", content)
end, { nargs = 1 })
