local ok, go = pcall(require, "go")
if not ok then
    vim.notify("Unable to require go", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

go.setup({dap_debug = true, dap_debug_gui = true})

-- Run gofmt + goimport on save
vim.api.nvim_exec(
    [[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]],
    false)
