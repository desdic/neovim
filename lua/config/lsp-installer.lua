local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
    vim.notify("Unable to require nvim-lsp-installer", "error")
    return
end

local servok, lsp_install_srv = pcall(require, "nvim-lsp-installer.servers")
if not servok then
    vim.notify("Unable to require nvim-lsp-installer.servers", "error")
    return
end

local handok, lsphandlers = pcall(require, "lsp.handlers")
if not handok then
    vim.notify("Unable to require lsp.handlers", "error")
    return
end

local myconfigs = {
    "bashls", "yamlls", "pyright", "solargraph", "gopls", "dockerls", "clangd",
    "sumneko_lua", "jsonls"
}

local myservers = {
    "bashls", "yamlls", "pyright", "efm", "solargraph", "gopls", "dockerls",
    "clangd", "sumneko_lua", "jsonls"
}

for _, myserver in ipairs(myservers) do
    local _, requested_server = lsp_install_srv.get_server(myserver)
    if not requested_server:is_installed() then
        -- Queue the server to be installed
        requested_server:install()
    end
end

local function has_config(tab, val)
    for _, value in ipairs(tab) do if value == val then return true end end

    return false
end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
    local opts = {
        on_attach = lsphandlers.on_attach,
        capabilities = lsphandlers.capabilities,
        debounce_text_changes = 150
    }

    if has_config(myconfigs, server.name) then
        local ok, srvopts = pcall(require, "lsp.settings." .. server.name)
        if not ok then
            vim.notify("Unable to require lsp.settings." .. server.name)
        else
            opts = vim.tbl_deep_extend("force", srvopts, opts)
        end
    end

    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
end)
