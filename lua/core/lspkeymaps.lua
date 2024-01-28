local M = {}

M.setkeys = function(ev)
    local silent_bufnr = function(desc)
        return { silent = true, buffer = ev.buf, desc = desc }
    end

    local has_cap = function(cap)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        return client.server_capabilities[cap .. "Provider"]
    end

    local has_plugin = function(plugin)
        return pcall(require, plugin)
    end

    require("core.format").on_attach(ev, ev.buf)
    local format = require("core.format").format

    local keymap = vim.keymap.set
    keymap("n", "gl", vim.diagnostic.open_float, silent_bufnr("Line diagnostics"))
    keymap("n", "<leader>cl", "<cmd>LspInfo<cr>", { silent = true, desc = "LSP info" })
    keymap("n", "<leader>cr", "<cmd>LspRestart<cr>", { silent = true, desc = "Restart LSP server" })
    keymap("n", "<leader>xd", "<cmd>Telescope diagnostics<cr>", { silent = true, desc = "Telescope Diagnostics" })
    keymap("n", "gd", "<cmd>Telescope lsp_definitions<cr>", silent_bufnr("Goto Definition"))
    keymap("n", "gr", "<cmd>Telescope lsp_references<cr>", silent_bufnr("References"))
    keymap("n", "gi", "<cmd>Telescope lsp_implementations<cr>", silent_bufnr("Goto Implementation"))
    keymap("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", silent_bufnr("Goto Type Definition"))
    keymap("n", "K", vim.lsp.buf.hover, silent_bufnr("Hover"))

    keymap("n", "<C-j>", vim.diagnostic.goto_next, silent_bufnr("Next Diagnostic"))
    keymap("n", "<C-k>", vim.diagnostic.goto_prev, silent_bufnr("Prev Diagnostic"))

    if has_cap("signatureHelp") then
        keymap("n", "gss", vim.lsp.buf.signature_help, silent_bufnr("Signature Help"))
    end

    if has_plugin("aerial") then
        keymap("n", "{", "<cmd>AerialNext<cr>", silent_bufnr("Aerial next"))
        keymap("n", "}", "<cmd>AerialPrev<cr>", silent_bufnr("Aerial prev"))
    end

    if not has_plugin("inc_rename") then
        keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
    end

    keymap({ "n", "v" }, "<leader>ca", function()
        if vim.bo.filetype == "go" then
            if has_plugin("go") then
                return vim.cmd("GoCodeAction")
            end
        end
        return vim.lsp.buf.code_action()
    end, silent_bufnr("Code Action"))

    if has_cap("documentFormatting") then
        keymap("n", "<leader>f", format, silent_bufnr("Format Document"))
    end
    if has_cap("documentRangeFormatting") then
        keymap("v", "<leader>f", format, silent_bufnr("Format Range"))
    end
end

return M
