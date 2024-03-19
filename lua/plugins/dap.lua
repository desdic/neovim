return {
    {
        "mfussenegger/nvim-dap",
        enabled = false,
        keys = {
            {
                "<F4>",
                function()
                    require("dapui").toggle()
                end,
                desc = "Start DAP UI",
            },
            {
                "<F5>",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "DAP Set breakpoint",
            },
            {
                "<F9>",
                function()
                    require("dap").continue()
                end,
                desc = "Start/Continue",
            },
            {
                "<F1>",
                function()
                    require("dap").step_over()
                end,
                desc = "DAP Step over",
            },
            {
                "<F2>",
                function()
                    require("dap").step_into()
                end,
                desc = "DAP Step into",
            },
            {
                "<F3>",
                function()
                    require("dap").step_out()
                end,
                desc = "DAP Step out",
            },
        },
        dependencies = {
            { "theHamsta/nvim-dap-virtual-text" }, -- virtual text for debugger
            {
                "mfussenegger/nvim-dap-python",    -- python debugger
                config = function()
                    require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
                end,
            },
            {
                "leoluz/nvim-dap-go",
                config = function()
                    require("dap-go").setup()
                end,
            },                          -- go debugger
            {
                "rcarriga/nvim-dap-ui", -- debugger UI
                config = function()
                    require("dapui").setup()
                end,
            },
        },
        config = function()
            local dap = require("dap")
            local sign = vim.fn.sign_define

            sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
            sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
            sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })

            -- https://github.com/microsoft/vscode-cpptools/releases/latest
            -- download cpptools-linux.vsix
            -- cd ~/software/cpptools-linux
            -- unzip ~/Downloads/cpptools-linux.vsix
            -- chmod +x extension/debugAdapters/bin/OpenDebugAD7
            dap.adapters.cppdbg = {
                type = "executable",
                id = "cppdbg",
                command = os.getenv("HOME") .. "/software/vscode-cpptools/extension/debugAdapters/bin/OpenDebugAD7",
            }

            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = "/usr/bin/codelldb",
                    args = { "--port", "${port}", "--settings", '{"showDisassembly" : "never"}' },
                },
            }

            dap.configurations.cpp = {
                {
                    name = "Launch file",
                    type = "cppdbg",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = true,
                    setupCommands = {
                        {
                            text = "-enable-pretty-printing",
                            description = "enable pretty printing",
                            ignoreFailures = false,
                        },
                    },
                },
                {
                    name = "Attach to gdbserver :1234",
                    type = "cppdbg",
                    request = "launch",
                    MIMode = "gdb",
                    miDebuggerServerAddress = "localhost:1234",
                    miDebuggerPath = "/usr/bin/gdb",
                    cwd = "${workspaceFolder}",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                },
            }

            dap.configurations.c = dap.configurations.cpp -- Reuse for c

            dap.configurations.rust = {
                {
                    name = "Rust debug",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = true,
                },
            }
        end,
    },
}
