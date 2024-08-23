return {
    {
        "mfussenegger/nvim-dap",
        keys = {
            {
                "<leader>du",
                function()
                    require("dapui").toggle()
                end,
                desc = "Start DAP UI",
            },
            {
                "<leader>db",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "DAP Set breakpoint",
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
                "<leader>dl",
                function()
                    require("osv").launch({ port = 8086 })
                end,
                desc = "Launch debug instance",
            },
        },
        dependencies = {
            {
                "mfussenegger/nvim-dap-python",
                ft = { "python" },
                config = function()
                    require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
                end,
            },
            {
                "leoluz/nvim-dap-go",
                ft = { "go" },
                config = function()
                    require("dap-go").setup()
                end,
            },
            {
                "rcarriga/nvim-dap-ui",
                config = function()
                    require("dapui").setup()
                end,
            },
            {
                "nvim-neotest/nvim-nio",
            },
            {
                "julianolf/nvim-dap-lldb",
                ft = { "c", "cpp", "rust", "zig" },
                opts = { codelldb_path = "/sbin/codelldb" },
            },
            {
                "jbyuki/one-small-step-for-vimkind",
                ft = { "lua" },
                config = function()
                    local dap = require("dap")
                    dap.adapters.nlua = function(callback, conf)
                        local adapter = {
                            type = "server",
                            host = conf.host or "127.0.0.1",
                            port = conf.port or 8086,
                        }
                        if conf.start_neovim then
                            local dap_run = dap.run
                            dap.run = function(c)
                                adapter.port = c.port
                                adapter.host = c.host
                            end
                            require("osv").run_this()
                            dap.run = dap_run
                        end
                        callback(adapter)
                    end
                    dap.configurations.lua = {
                        {
                            type = "nlua",
                            request = "attach",
                            name = "Run this file",
                            start_neovim = {},
                        },
                        {
                            type = "nlua",
                            request = "attach",
                            name = "Attach to running Neovim instance (port = 8086)",
                            port = 8086,
                        },
                    }
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
