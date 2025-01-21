local M = {}

M.setkeys = function(ev)
    local silent_bufnr = function(desc)
        return { silent = true, buffer = ev.buf, desc = desc }
    end

    -- Check if we have capability
    local has_cap = function(cap)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client == nil then
            return false
        end
        return client.server_capabilities[cap .. "Provider"]
    end

    require("core.format").on_attach(ev, ev.buf)
    local format = require("core.format").format

    local keymap = vim.keymap.set
    local ft = vim.bo.ft

    local is_go = function(filetype)
        if filetype == "go" or filetype == "gomod" or filetype == "gosum" then
            return true
        end
        return false
    end

    -- keymap("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", silent_bufnr("Goto definition"))
    keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", silent_bufnr("Goto definition"))
    keymap("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", silent_bufnr("Goto Implementation"))
    keymap("n", "gr", "<cmd>FzfLua lsp_references<cr>", silent_bufnr("References"))
    keymap("n", "gt", "<cmd>FzfLua lsp_typedefs<cr>", silent_bufnr("Goto Type Definition"))
    keymap("n", "gl", "<cmd>FzfLua lsp_finder<cr>", silent_bufnr("LSP finder"))
    keymap("n", "gp", "<cmd>FzfLua lsp_document_diagnostics<cr>", silent_bufnr("LSP diagnostic"))

    keymap("n", "<leader>tf", require("core.format").toggle, { desc = "Toggle format on Save" })
    keymap("n", "gD", vim.lsp.buf.declaration, silent_bufnr("Goto declaration"))
    keymap("n", "K", vim.lsp.buf.hover, silent_bufnr("Hover"))
    keymap("n", "<leader>rn", vim.lsp.buf.rename, silent_bufnr("Rename"))

    keymap("n", "]d", vim.diagnostic.goto_next, silent_bufnr("Next Diagnostic"))
    keymap("n", "[d", vim.diagnostic.goto_prev, silent_bufnr("Prev Diagnostic"))

    if has_cap("signatureHelp") then
        keymap("n", "gss", vim.lsp.buf.signature_help, silent_bufnr("Signature Help"))
    end

    -- Preferences for code actions
    keymap({ "n", "v" }, "<leader>ca", function()
        if is_go(ft) then
            return vim.cmd("GoCodeAction")
        end
        return vim.lsp.buf.code_action()
    end, silent_bufnr("Code Action"))

    keymap({ "n" }, "<leader>cl", function()
        if is_go(ft) then
            return vim.cmd("GoCodeLenAct")
        end
        return vim.lsp.codelens.run()
    end)

    if has_cap("documentFormatting") then
        keymap("n", "<leader>fm", format, silent_bufnr("[F]or[m]at Document"))
    end
    if has_cap("documentRangeFormatting") then
        keymap("v", "<leader>fm", format, silent_bufnr("[F]or[m]at Range"))
    end

    keymap("n", "<leader>lh", function()
        local opt = { buf = 0 }
        local ok = pcall(vim.lsp.inlay_hint.enable, vim.lsp.inlay_hint.is_enabled(opt))
        if ok then
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(opt))
        else
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(opt), opt)
        end
    end, { desc = "LSP | Toggle Inlay Hints", silent = true })
end

return M
