local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
    vim.notify("Unable to require lspconfig", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
    vim.notify("Unable to require cmp_nvim_lsp", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

local nok, navic = pcall(require, "nvim-navic")
if not nok then
    vim.notify("Unable to require nvim-navic", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
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

    vim.keymap.set("n", "<C-k>", function()
        vim.diagnostic.goto_prev({border = "rounded"})
    end, {noremap = true, silent = true, desc = "Goto previous diagnostic"})

    vim.keymap.set("n", "<C-j>", function()
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

    vim.keymap.set("n", "<Leader>s", ":LSoutlineToggle<CR>")

    vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
    vim.cmd(
        [[ command! FormatSync execute 'lua vim.lsp.buf.formatting_sync()' ]])
    vim.cmd(
        [[ command! FormatRange execute 'lua vim.lsp.buf.range_formatting()' ]])
end

local on_attach = function(client, bufnr)
    vim.keymap.set("n", "<Leader>f", function() vim.lsp.buf.format() end,
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
    if client.name ~= "pylsp" and client.name ~= "null-ls" and client.name ~=
        "efm" then navic.attach(client, bufnr) end

    lsp_keymaps(bufnr)
end

local capabilities = cmp_nvim_lsp.default_capabilities()

local signs = {Error = " ", Warn = " ", Hint = "ﴞ ", Info = " "}
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = ""})
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

vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded"})

vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, {border = "rounded"})

-- Go
lspconfig["gopls"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        gopls = {
            analyses = {unusedparams = true},
            staticcheck = true,
            gofumpt = true
        }
    },
    root_dir = lspconfig.util.root_pattern(".git", "go.mod", "."),
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        gofumpt = true
    }
})

-- Lua
lspconfig["sumneko_lua"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = { -- custom settings for lua
        Lua = {
            -- make the language server recognize "vim" global
            diagnostics = {globals = {"vim"}},
            workspace = {
                -- make language server aware of runtime files
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true
                }
            }
        }
    }
})

-- Python
lspconfig["pylsp"].setup({capabilities = capabilities, on_attach = on_attach})

lspconfig["pyright"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true
            }
        }
    }
})

-- Bash
lspconfig["bashls"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = {"sh", "zsh"}
})

-- Docker
lspconfig["bashls"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
    root_dir = vim.loop.cwd
})

-- C
local utf16cap = capabilities
utf16cap.offsetEncoding = {"utf-16"}
lspconfig["clangd"].setup({
    cmd = {"clangd", "--background-index"},
    capabilities = utf16cap,
    on_attach = on_attach
})

lspconfig["efm"].setup({capabilities = capabilities, on_attach = on_attach})

lspconfig["jsonls"].setup({capabilities = capabilities, on_attach = on_attach})

lspconfig["perlnavigator"].setup({
    capabilities = capabilities,
    on_attach = on_attach
})

lspconfig["yamlls"].setup({capabilities = capabilities, on_attach = on_attach})

lspconfig["solargraph"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = {"ruby", "rb", "erb", "rakefile"}
})

lspconfig["rust_analyzer"].setup({
    capabilities = capabilities,
    on_attach = on_attach
})

vim.cmd([[autocmd BufWritePre *.rs,*.lua lua vim.lsp.buf.format()]])
