local M = {}

function M.on_attach(client, buffer)
    local self = M.new(client, buffer)


    self:map("<leader>gl", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
    self:map("<leader>cl", "LspInfo", { desc = "Lsp Info" })
    self:map("<leader>cr", "LspRestart", { desc = "Restart LSP server" })

    self:map("<leader>xd", "Telescope diagnostics", { desc = "Telescope Diagnostics" })
    self:map("gd", "Telescope lsp_definitions", { desc = "Goto Definition" })
    self:map("gr", "Telescope lsp_references", { desc = "References" })
    self:map("gD", "Telescope lsp_declarations", { desc = "Goto Declaration" })
    self:map("gi", "Telescope lsp_implementations", { desc = "Goto Implementation" })
    self:map("gt", "Telescope lsp_type_definitions", { desc = "Goto Type Definition" })
    self:map("K", vim.lsp.buf.hover, { desc = "Hover" })
    self:map("gs", vim.lsp.buf.signature_help, { desc = "Signature Help", has = "signatureHelp" })
    self:map("<C-j>", M.diagnostic_goto(true), { desc = "Next Diagnostic" })
    self:map("<C-k>", M.diagnostic_goto(false), { desc = "Prev Diagnostic" })
    self:map("]e", M.diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
    self:map("[e", M.diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
    self:map("]w", M.diagnostic_goto(true, "WARNING"), { desc = "Next Warning" })
    self:map("[w", M.diagnostic_goto(false, "WARNING"), { desc = "Prev Warning" })
    self:map("<leader>ca", M.code_action, { desc = "Code Action", mode = { "n", "v" }, has = "codeAction" })
    local format = require("plugins.lsp.format").format
    self:map("<leader>f", format, { desc = "Format Document", has = "documentFormatting" })
    self:map("<leader>f", format, { desc = "Format Range", mode = "v", has = "documentRangeFormatting" })

    if pcall(require, "aerial") then
        self:map("{", "AerialNext", { desc = "AerialNext" })
        self:map("}", "AerialPrev", { desc = "AerialPrev" })
    end

    if not pcall(require, "inc_rename") then
        self:map("<leader>rn", function() vim.lsp.buf.rename() end, { expr = false, desc = "Rename", has = "rename" })
    end

end

function M.new(client, buffer)
    return setmetatable({ client = client, buffer = buffer }, { __index = M })
end

function M:has(cap)
    return self.client.server_capabilities[cap .. "Provider"]
end

function M:map(lhs, rhs, opts)
    opts = opts or {}
    if opts.has and not self:has(opts.has) then
        return
    end
    vim.keymap.set(
        opts.mode or "n",
        lhs,
        type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs,
        { silent = true, buffer = self.buffer, expr = opts.expr, desc = opts.desc }
    )
end

function M.code_action()
    if vim.bo.filetype == "go" then
        if pcall(require, "go") then
            return vim.cmd("GoCodeAction")
        end
    end
    return vim.lsp.buf.code_action()
end

function M.diagnostic_goto(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go({ severity = severity })
    end
end

return M
