return {
    {
        "mfussenegger/nvim-dap",
        keys = {
            {
                "<leader>db",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "DAP Set/Toggle breakpoint",
            },
            {
                "<leader>dB",
                function()
                    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end,
                desc = "DAP Set breakpoint",
            },
            {
                "<leader>dc",
                function()
                    require("dap").continue()
                end,
                desc = "Start/Continue",
            },
            {
                "<leader>dl",
                function()
                    require("dap").run_last()
                end,
                desc = "Run last",
            },
            {
                "<leader>do>",
                function()
                    require("dap").step_over()
                end,
                desc = "DAP Step over",
            },
            {
                "<leader>di",
                function()
                    require("dap").step_into()
                end,
                desc = "DAP Step into",
            },
            {
                "<leader>dO",
                function()
                    require("dap").step_out()
                end,
                desc = "DAP Step out",
            },
            {
                "<leader>dr",
                function()
                    require("dap").clear_breakpoints()
                end,
                desc = "DAP Clear all breakpoints",
            },
        },
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
                keys = {
                    {
                        "<leader>du",
                        function()
                            require("dapui").toggle()
                        end,
                        desc = "Start DAP UI",
                    },
                },
                dependencies = {
                    "nvim-neotest/nvim-nio",
                },
                opts = {},
            },
            {
                "leoluz/nvim-dap-go",
                ft = { "go" },
                config = function()
                    require("dap-go").setup()
                end,
            },
            {
                "julianolf/nvim-dap-lldb",
                ft = { "c", "cpp", "rust", "zig" },
                config = function()
                    local dap = require("dap")
                    local last_program = nil

                    dap.adapters.lldb = {
                        type = "executable",
                        command = "/sbin/codelldb",
                        name = "lldb",
                    }

                    dap.configurations.cpp = {
                        {
                            name = "Debug with LLDB",
                            type = "lldb",
                            request = "launch",
                            program = function()
                                if last_program then
                                    return last_program
                                end
                                last_program = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                                return last_program
                            end,
                            cwd = "${workspaceFolder}",
                            stopOnEntry = false,
                            args = {},
                            runInTerminal = false,
                        },
                    }

                    vim.api.nvim_create_user_command("DapResetBinary", function()
                        last_program = nil
                        print("DAP binary reset. Next debug session will ask for a path.")
                    end, {})

                    dap.configurations.c = dap.configurations.cpp
                    dap.configurations.rust = dap.configurations.cpp
                    dap.configurations.zig = dap.configurations.cpp
                end,
            },
        },
        config = function()
            local sign = vim.fn.sign_define

            vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

            sign("DapBreakpoint", { text = " ", texthl = "", linehl = "", numhl = "" })
            sign("DapBreakpointCondition", { text = " ", texthl = "", linehl = "", numhl = "" })
            sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
            sign("DapStopped", { text = "󰁕", texthl = "DiagnosticWarn", linehl = "DapStoppedLine", numhl = "" })
            sign("DapBreakpointRejected", { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "" })
        end,
    },
}
