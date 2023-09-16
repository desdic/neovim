local M = {}

M.autoformat = false

function M.toggle()
    M.autoformat = not M.autoformat
    vim.notify(M.autoformat and "Enabled format on save" or "Disabled format on save")
end

function M.format()
    local buf = vim.api.nvim_get_current_buf()

    vim.lsp.buf.format({
        bufnr = buf,
    })
end

function M.on_attach(client, buf)
    if client.supports_method("textDocument/formatting") then
        if vim.o.filetype == "go" then
            M.autoformat = true
        end
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormat." .. buf, {}),
            buffer = buf,
            callback = function()
                if M.autoformat then
                    M.format()
                end
            end,
        })
    end
end

return M
