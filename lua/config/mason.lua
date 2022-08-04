local ok, mason = pcall(require, "mason")
if not ok then
    vim.notify("Unable to require mason", vim.lsp.log_levels.ERROR,
			   {title = "Plugin error"})
    return
end

local oklsp, masonlsp = pcall(require, "mason-lspconfig")
if not oklsp then
    vim.notify("Unable to require mason-lspconfig", vim.lsp.log_levels.ERROR,
			   {title = "Plugin error"})
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

mason.setup()

local myconfigs = {
    ["gopls"] = true,
    ["sumneko_lua"] = true,
    ["bashls"] = true,
    ["yamlls"] = true,
    ["pyright"] = true,
	["pylsp"] = true,
    ["efm"] = false,
    ["solargraph"] = true,
    ["dockerls"] = true,
    ["clangd"] = true,
    ["jsonls"] = true,
    ["perlnavigator"] = true
}

local shouldinstall = {}
for myserver, enabled in pairs(myconfigs) do
	if enabled then
		table.insert(shouldinstall, myserver)
	end
end

masonlsp.setup({
	ensure_installed = shouldinstall,
})

for myserver, enabled in pairs(myconfigs) do
    -- local _, requested_server = lsp_install_srv.get_server(myserver)
    if enabled then
        -- if not requested_server:is_installed() then
        --     -- Queue the server to be installed
        --     vim.notify("Queing " .. myserver, vim.lsp.log_levels.INFO,
        --                {title = "LSP installer"})
        --     requested_server:install()
        -- end

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

    -- else
    --     if requested_server:is_installed() then
    --         vim.notify("Uninstalling " .. myserver, vim.lsp.log_levels.INFO,
    --                    {title = "LSP installer"})
    --         requested_server:uninstall()
    --     end
    end
end
