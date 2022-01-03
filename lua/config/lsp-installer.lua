local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
    vim.notify("Unable to require nvim-lsp-installer", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

local servok, lsp_install_srv = pcall(require, "nvim-lsp-installer.servers")
if not servok then
    vim.notify("Unable to require nvim-lsp-installer.servers",
               vim.lsp.log_levels.ERROR, {title = "Plugin error"})
    return
end

local handok, lsphandlers = pcall(require, "lsp.handlers")
if not handok then
    vim.notify("Unable to require lsp.handlers", vim.lsp.log_levels.ERROR,
               {title = "Config error"})
    return
end

local myconfigs = {
    ["bashls"] = true,
    ["yamlls"] = true,
    ["pyright"] = true,
    ["solargraph"] = true,
    ["gopls"] = true,
    ["dockerls"] = true,
    ["clangd"] = true,
    ["sumneko_lua"] = true,
    ["jsonls"] = true
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

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
    local opts = {
        on_attach = lsphandlers.on_attach,
        capabilities = lsphandlers.capabilities,
        debounce_text_changes = 150
    }

    if myconfigs[server.name] then
        local ok, srvopts = pcall(require, "lsp.settings." .. server.name)
        if not ok then
            vim.notify("Unable to require lsp.settings." .. server.name,
                       vim.lsp.log_levels.ERROR, {title = "Config error"})
        else
            opts = vim.tbl_deep_extend("force", srvopts, opts)
        end
    end

    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
end)
