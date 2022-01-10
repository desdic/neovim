local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    vim.notify("Unable to requre lspconfig", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

-- LspInfo is ment as a debugging tool but its kinda hard to
-- read when it melts into the current background. This will add
-- a border
local statusui, win = pcall(require, "lspconfig.ui.windows")
if statusui then
    local _default_opts = win.default_opts

    win.default_opts = function(options)
        local opts = _default_opts(options)
        opts.border = "single"
        return opts
    end
end

status_ok, _ = pcall(require, "config.lsp-installer")
if not status_ok then
    vim.notify("Unable to requre config.lsp-installer",
               vim.lsp.log_levels.ERROR, {title = "Config error"})
    return
end

local statusl_ok, lsphandlers = pcall(require, "lsp.handlers")
if not statusl_ok then
    vim.notify("Unable to requre lsp.handlers", vim.lsp.log_levels.ERROR,
               {title = "Config error"})
    return
end

local statusc_ok, cfgnullls = pcall(require, "config.null-ls")
if not statusc_ok then
    vim.notify("Unable to requre config.null-ls", vim.lsp.log_levels.ERROR,
               {title = "Config error"})
    return
end

lsphandlers.setup()
cfgnullls.config()
