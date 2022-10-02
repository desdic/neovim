local M = {}

local nok, navic = pcall(require, "nvim-navic")
if not nok then
    vim.notify("Unable to require nvim-navic", vim.lsp.log_levels.ERROR,
			   {title = "Plugin error"})
    return
end

M.setup = function()
    local signs = {
        {name = "DiagnosticSignError", text = ""},
        {name = "DiagnosticSignWarn", text = ""},
        {name = "DiagnosticSignHint", text = ""},
        {name = "DiagnosticSignInfo", text = ""}
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name,
                           {texthl = sign.name, text = sign.text, numhl = ""})
    end

    local config = {
        -- disable virtual text
        virtual_text = false,
        -- show signs
        signs = {active = signs},
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = ""
        }
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
                                                 vim.lsp.handlers.hover,
                                                 {border = "rounded"})

    vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, {border = "rounded"})
end

local function lsp_keymaps(bufnr)
    local tsbuildinok, tsbuildin = pcall(require, "telescope.builtin")
    if tsbuildinok then
        vim.keymap.set("n", "gr", function() tsbuildin.lsp_references() end,
                       {noremap = true, desc = "Show references"})
    end

    local go, _ = pcall(require, "go")
    if go then
        vim.keymap.set("n", "<Leader>ca", ":GoCodeAction<CR>", {
            silent = true,
            noremap = true,
            desc = "Show code actions"
        })
    end

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end,
                   {noremap = true, desc = "Goto definition"})

    vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end,
                   {noremap = true, desc = "Goto type definition"})

    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end,
                   {noremap = true, desc = "Goto declaration"})

    vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end,
                   {noremap = true, desc = "Goto implementation"})

    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end,
                   {noremap = true, desc = "Show documentation"})

    vim.keymap.set("n", "<Leader>rr", function() vim.lsp.buf.rename() end,
                   {noremap = true, desc = "Rename via LSP"})

    vim.keymap.set("n", "<C-p>", function()
        vim.diagnostic.goto_prev({border = "rounded"})
    end, {noremap = true, silent = true, desc = "Goto previous diagnostic"})

    vim.keymap.set("n", "<C-n>", function()
        vim.diagnostic.goto_next({border = "rounded"})
    end, {noremap = true, silent = true, desc = "Goto next diagnostic"})

    vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end,
                   {noremap = true, silent = true, desc = "Open diagnostic"})

    -- vim.keymap.set("n", "<Leader>gr", function() vim.lsp.buf.rename() end,
    --                {noremap = true, silent = true, desc = "LSP rename"})

    vim.keymap.set("n", "<Leader>gs",
                   function() vim.lsp.buf.signature_help() end, {
        noremap = true,
        silent = true,
        desc = "Show signature help"
    })

    vim.keymap.set("n", "<Leader>s",
                   function() tsbuildin.lsp_document_symbols() end,
                   {noremap = true, silent = true, desc = "Show symbols"})

    vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
    vim.cmd(
        [[ command! FormatSync execute 'lua vim.lsp.buf.formatting_sync()' ]])
    vim.cmd(
        [[ command! FormatRange execute 'lua vim.lsp.buf.range_formatting()' ]])
end

-- Prepare for next version of lsp-config
-- local util = require("vim.lsp.util")
-- local formatting_callback = function(client, bufnr)
-- 	vim.keymap.set("n", "<leader>f", function()
-- 		local params = util.make_formatting_params({})
-- 		client.request("textDocument/formatting", params, nil, bufnr)
-- 		vim.lsp.buf.formatting()
-- 	end, { buffer = bufnr })
-- end

M.on_attach = function(client, bufnr)

    -- Alternativ solution for lsp_config update
    -- https://github.com/b0o/nvim-conf/commit/50a9478334f9cfffde9ce889980f9585a69c54f2
    vim.keymap.set("n", "<Leader>f",
                   function() vim.lsp.buf.formatting_sync() end,
                   {noremap = true, silent = true, desc = "Do formatting"})

    if client.name == "tsserver" then
        client.server_capabilities.document_formatting = false
    elseif client.name == "sumneko_lua" then
        client.server_capabilities.document_formatting = false
    elseif client.name == "gopls" then
        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false
    end

	-- Avoid attaching multiple times
	if client.name ~= "pylsp" and client.name ~= "null-ls" then
		navic.attach(client, bufnr)
	end

	-- Highlight based on LSP
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup("lsp_document_highlight", {clear = true})
        vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = "lsp_document_highlight"
        })
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = vim.lsp.buf.document_highlight,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "Document Highlight"
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            callback = vim.lsp.buf.clear_references,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "Clear All the References"
        })
    end

    lsp_keymaps(bufnr)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
    vim.notify("Unable to require cmp_nvim_lsp", "error")
    return
end

M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

return M
