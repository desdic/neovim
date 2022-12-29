local M = {
    "mfussenegger/nvim-dap",
    ft = {"go", "python", "c", "cpp"},

    dependencies = {
        {"theHamsta/nvim-dap-virtual-text"}, -- virtual text for debugger
        {
            "mfussenegger/nvim-dap-python", -- python debugger
            config = function() require("dap-python").setup("~/.virtualenvs/debugpy/bin/python") end
        }, {"leoluz/nvim-dap-go", config = function() require("dap-go").setup() end}, -- go debugger
        {
            "rcarriga/nvim-dap-ui", -- debugger UI
            config = function() require("dapui").setup() end
        }
    }
}

function M.init()
    vim.keymap.set("n", "<F4>", function() require("dapui").toggle() end, {noremap = true, desc = "Toggle debugging"})
    vim.keymap.set("n", "<F5>", function() require("dap").toggle_breakpoint() end,
                   {noremap = true, desc = "Set breakpoint"})
    vim.keymap.set("n", "<F9>", function() require("dap").continue() end, {noremap = true, desc = "Continue or start"})
    vim.keymap.set("n", "<F1>", function() require("dap").step_over() end, {noremap = true, desc = "Step over"})
    vim.keymap.set("n", "<F2>", function() require("dap").step_into() end, {noremap = true, desc = "Step into"})
    vim.keymap.set("n", "<F3>", function() require("dap").step_out() end, {noremap = true, desc = "Step out"})
end

function M.config()
    local ok, dap = pcall(require, "dap")
    if not ok then
        vim.notify("Unable to require dap", vim.lsp.log_levels.ERROR, {title = "Plugin error"})
        return
    end

    local sign = vim.fn.sign_define

    sign("DapBreakpoint", {text = "●", texthl = "DapBreakpoint", linehl = "", numhl = ""})
    sign("DapBreakpointCondition", {text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = ""})
    sign("DapLogPoint", {text = "◆", texthl = "DapLogPoint", linehl = "", numhl = ""})

    -- https://github.com/microsoft/vscode-cpptools/releases/latest
    -- download cpptools-linux.vsix
    -- cd ~/software/cpptools-linux
    -- unzip ~/Downloads/cpptools-linux.vsix
    -- chmod +x extension/debugAdapters/bin/OpenDebugAD7
    dap.adapters.cppdbg = {
        type = "executable",
        id = "cppdbg",
        command = os.getenv("HOME") .. "/software/vscode-cpptools/extension/debugAdapters/bin/OpenDebugAD7"
    }

    dap.configurations.cpp = {
        {
            name = "Launch file",
            type = "cppdbg",
            request = "launch",
            program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
            cwd = "${workspaceFolder}",
            stopOnEntry = true,
            setupCommands = {
                {text = "-enable-pretty-printing", description = "enable pretty printing", ignoreFailures = false}
            }
        }, {
            name = "Attach to gdbserver :1234",
            type = "cppdbg",
            request = "launch",
            MIMode = "gdb",
            miDebuggerServerAddress = "localhost:1234",
            miDebuggerPath = "/usr/bin/gdb",
            cwd = "${workspaceFolder}",
            program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end
        }
    }

    dap.configurations.c = dap.configurations.cpp -- Reuse for c

    vim.fn.sign_define("DapBreakpoint", {text = "🛑", texthl = "", linehl = "", numhl = ""})
end

return M
