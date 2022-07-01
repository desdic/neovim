local ok, dap = pcall(require, "dap")
if not ok then
    vim.notify("Unable to require dap", vim.lsp.log_levels.ERROR,
			   {title = "Plugin error"})
    return
end

local okgo, dapgo = pcall(require, "dap-go")
if not okgo then
    vim.notify("Unable to require dap-go", vim.lsp.log_levels.ERROR,
			   {title = "Plugin error"})
    return
end

local okpy, dappy = pcall(require, "dap-python")
if not okpy then
    vim.notify("Unable to require dap-python", vim.lsp.log_levels.ERROR,
			   {title = "Plugin error"})
    return
end


local okui, dapui = pcall(require, "dapui")
if not okui then
    vim.notify("Unable to require dapui", vim.lsp.log_levels.ERROR,
			   {title = "Plugin error"})
    return
end

dapgo.setup()
dappy.setup("~/.virtualenvs/debugpy/bin/python")
dapui.setup()

vim.keymap.set("n", "<F4>", function() dapui.toggle() end,
	{noremap = true, desc = "Toggle debugging"})

vim.keymap.set("n", "<F5>", function() dap.toggle_breakpoint() end,
	{noremap = true, desc = "Set breakpoint"})

vim.keymap.set("n", "<F9>", function() dap.continue() end,
	{noremap = true, desc = "Continue or start"})

vim.keymap.set("n", "<F1>", function() dap.step_over() end,
	{noremap = true, desc = "Step over"})

vim.keymap.set("n", "<F2>", function() dap.step_into() end,
	{noremap = true, desc = "Step into"})

vim.keymap.set("n", "<F3>", function() dap.step_out() end,
	{noremap = true, desc = "Step out"})
