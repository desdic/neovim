local M = {}

M.setkeys = function(ev)
    local silent_bufnr = function(desc)
        return { silent = true, buffer = ev.buf, desc = desc }
    end

    -- Check if we have capability
    local has_cap = function(cap)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        return client.server_capabilities[cap .. "Provider"]
    end

    -- Check if plugin is loaded
    local has_plugin = function(plugin)
        return pcall(require, plugin)
    end

    require("core.format").on_attach(ev, ev.buf)
    local format = require("core.format").format

    local keymap = vim.keymap.set
    keymap("n", "<Leader>tf", require("core.format").toggle, { desc = "Toggle format on Save" })
    keymap("n", "gl", vim.diagnostic.open_float, silent_bufnr("Line diagnostics"))
    keymap("n", "gd", vim.lsp.buf.definition, silent_bufnr("Goto definition"))
    keymap("n", "gD", vim.lsp.buf.declaration, silent_bufnr("Goto declaration"))
    keymap("n", "gr", "<cmd>Telescope lsp_references<cr>", silent_bufnr("References"))
    keymap("n", "gi", "<cmd>Telescope lsp_implementations<cr>", silent_bufnr("Goto Implementation"))
    keymap("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", silent_bufnr("Goto Type Definition"))
    keymap("n", "K", vim.lsp.buf.hover, silent_bufnr("Hover"))
    keymap("n", "<leader>rn", vim.lsp.buf.rename, silent_bufnr("Rename"))

    keymap("n", "<C-n>", vim.diagnostic.goto_next, silent_bufnr("Next Diagnostic"))
    keymap("n", "<C-p>", vim.diagnostic.goto_prev, silent_bufnr("Prev Diagnostic"))

    if has_cap("signatureHelp") then
        keymap("n", "gss", vim.lsp.buf.signature_help, silent_bufnr("Signature Help"))
    end

    if has_plugin("aerial") then
        keymap("n", "{", "<cmd>AerialNext<cr>", silent_bufnr("Aerial next"))
        keymap("n", "}", "<cmd>AerialPrev<cr>", silent_bufnr("Aerial prev"))
    end

    -- Preferences for code actions
    keymap({ "n", "v" }, "<leader>ca", function()
        if vim.bo.ft == "go" then
            return vim.cmd("GoCodeAction")
        elseif vim.bo.ft == "rust" then
            return vim.cmd.RustLsp("codeAction")
        end
        return vim.lsp.buf.code_action()
    end, silent_bufnr("Code Action"))

    if has_cap("documentFormatting") then
        keymap("n", "<leader>fm", format, silent_bufnr("[F]or[m]at Document"))
    end
    if has_cap("documentRangeFormatting") then
        keymap("v", "<leader>fm", format, silent_bufnr("[F]or[m]at Range"))
    end
end

return M
