local M = {
    -- Preferred defaults
    filetypes = {
        go = true,
        lua = true,
        rust = true,
        zig = true,
        glsl = true,
    },
}

function M.toggle()
    local filetype = vim.o.filetype
    M.filetypes[filetype] = vim.F.if_nil(not M.filetypes[filetype], false)
    local state = M.filetypes[filetype] and "enabled" or "disabled"
    vim.notify("Autoformat for " .. filetype .. " " .. state)
end

function M.format()
    local buf = vim.api.nvim_get_current_buf()

    local have_conform, conform = pcall(require, "conform")
    if have_conform then
        conform.format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 1000,
        })
        return
    end

    vim.lsp.buf.format({
        bufnr = buf,
    })
end

function M.on_attach(_, buf)
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("LspFormat." .. buf, {}),
        buffer = buf,
        callback = function()
            if M.filetypes[vim.o.filetype] then
                M.format()
            end
        end,
    })
end

return M
