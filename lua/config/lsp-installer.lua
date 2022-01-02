local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
    vim.notify("Unable to require nvim-lsp-installer")
    return
end

local myservers = {
    "bashls", "yamlls", "pyright", "efm", "solargraph", "gopls", "dockerls",
    "clangd", "sumneko_lua", "jsonls"
}

local lsp_installer_servers = require("nvim-lsp-installer.servers")
for _, myserver in ipairs(myservers) do
    local _, requested_server = lsp_installer_servers.get_server(myserver)
    if not requested_server:is_installed() then
        -- Queue the server to be installed
        requested_server:install()
    end
end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
    local opts = {
        on_attach = require("lsp.handlers").on_attach,
        capabilities = require("lsp.handlers").capabilities,
        debounce_text_changes = 150
    }

    if server.name == "solargraph" then
        local solargraph_opts = require("lsp.settings.solargraph")
        opts = vim.tbl_deep_extend("force", solargraph_opts, opts)
    end

    if server.name == "dockerls" then
        local dockerls_opts = require("lsp.settings.dockerls")
        opts = vim.tbl_deep_extend("force", dockerls_opts, opts)
    end

    if server.name == "yamlls" then
        local yamlls_opts = require("lsp.settings.yamlls")
        opts = vim.tbl_deep_extend("force", yamlls_opts, opts)
    end

    if server.name == "clangd" then
        local clangd_opts = require("lsp.settings.clangd")
        opts = vim.tbl_deep_extend("force", clangd_opts, opts)
    end

    if server.name == "pyright" then
        local pyright_opts = require("lsp.settings.pyright")
        opts = vim.tbl_deep_extend("force", pyright_opts, opts)
    end

    if server.name == "bashls" then
        local bashls_opts = require("lsp.settings.bashls")
        opts = vim.tbl_deep_extend("force", bashls_opts, opts)
    end

    if server.name == "jsonls" then
        local jsonls_opts = require("lsp.settings.jsonls")
        opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
    end

    if server.name == "sumneko_lua" then
        local sumneko_opts = require("lsp.settings.sumneko_lua")
        opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
    end

    if server.name == "gopls" then
        local gopls_opts = require("lsp.settings.gopls")
        opts = vim.tbl_deep_extend("force", gopls_opts, opts)
    end

    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
end)
