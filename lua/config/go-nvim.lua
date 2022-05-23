local ok, go = pcall(require, "go")
if not ok then
	vim.notify("Unable to require go", vim.lsp.log_levels.ERROR, { title = "Plugin error" })
	return
end

local okformat, goformat = pcall(require, "go.format")
if not okformat then
	vim.notify("Unable to require go.format", vim.lsp.log_levels.ERROR, { title = "Plugin error" })
	return
end

go.setup({ dap_debug = true, dap_debug_gui = true })

-- Run gofmt + goimport on save
-- vim.api.nvim_create_autocmd({"BufWritePre"}, {pattern = "*.go", callback = function() goformat.goimport() end})
--

local function org_imports()
  local clients = vim.lsp.buf_get_clients()
  for _, client in pairs(clients) do

    local params = vim.lsp.util.make_range_params(nil, client.offset_encoding)
    params.context = {only = {"source.organizeImports"}}

    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 5000)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end
  end
end

-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = { "*.go" },
--   callback = vim.lsp.buf.format,
-- })

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.go" },
  callback = org_imports,
})

