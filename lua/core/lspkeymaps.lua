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

    local keymap = vim.keymap.set
    local ft = vim.bo.ft

    local is_go = function(filetype)
        if filetype == "go" or filetype == "gomod" or filetype == "gosum" then
            return true
        end
        return false
    end

    local hassnacks, snacks = pcall(require, "snacks")
    if hassnacks then
        keymap("n", "gd", function()
            snacks.picker.lsp_definitions()
        end, silent_bufnr("Goto definition"))
        keymap("n", "gi", function()
            snacks.picker.lsp_implementations()
        end, silent_bufnr("Goto Implementation"))
        keymap("n", "gr", function()
            snacks.picker.lsp_references()
        end, silent_bufnr("References"))
        keymap("n", "gt", function()
            snacks.picker.lsp_type_definitions()
        end, silent_bufnr("Goto Type Definition"))
        keymap("n", "gl", function()
            snacks.picker.lsp_workspace_symbols()
        end, silent_bufnr("LSP finder"))
        keymap("n", "ge", function()
            snacks.picker.diagnostics()
        end, silent_bufnr("diagnostic"))
        keymap("n", "<leader>ss", function()
            snacks.picker.lsp_symbols()
        end, silent_bufnr("lsp_symbols"))
        keymap("n", "<leader>sS", function()
            snacks.picker.lsp_workspace_symbols()
        end, silent_bufnr("lsp_workspace_symbols"))
        keymap("n", "gD", function()
            snacks.picker.lsp_declarations()
        end, silent_bufnr("Goto declaration"))
    end

    keymap("n", "]d", function()
        vim.diagnostic.jump({ count = 1, float = true })
    end, silent_bufnr("Next Diagnostic"))

    keymap("n", "[d", function()
        vim.diagnostic.jump({ count = -1, float = true })
    end, silent_bufnr("Prev Diagnostic"))

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
