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

local lspconfigok, lspconfig = pcall(require, "lspconfig")
if not lspconfigok then
    vim.notify("Unable to require lspconfig", vim.lsp.log_levels.ERROR,
               {title = "Config error"})
    return
end

local myconfigs = {
    ["bashls"] = true,
    ["yamlls"] = true,
    ["pyright"] = true,
	["pylsp"] = true,
    ["efm"] = false,
    ["solargraph"] = true,
    ["gopls"] = true,
    ["dockerls"] = true,
    ["clangd"] = true,
    ["sumneko_lua"] = true,
    ["jsonls"] = true,
    ["perlnavigator"] = true
}

lsp_installer.setup()

for myserver, enabled in pairs(myconfigs) do
    local _, requested_server = lsp_install_srv.get_server(myserver)
    if enabled then
        if not requested_server:is_installed() then
            -- Queue the server to be installed
            vim.notify("Queing " .. myserver, vim.lsp.log_levels.INFO,
                       {title = "LSP installer"})
            requested_server:install()
        end

        local opts = {
            on_attach = lsphandlers.on_attach,
            capabilities = lsphandlers.capabilities,
            debounce_text_changes = 150
        }

        local ok, srvopts = pcall(require, "lsp.settings." .. myserver)
        if not ok then
            vim.notify("Unable to require lsp.settings." .. myserver,
                       vim.lsp.log_levels.ERROR, {title = "Config error"})
        else
            opts = vim.tbl_deep_extend("force", srvopts, opts)
        end

        lspconfig[myserver].setup(opts)
    else
        if requested_server:is_installed() then
            vim.notify("Uninstalling " .. myserver, vim.lsp.log_levels.INFO,
                       {title = "LSP installer"})
            requested_server:uninstall()
        end
    end
end
