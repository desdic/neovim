return {
    {
        "mfussenegger/nvim-dap",
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
            {
                "mfussenegger/nvim-dap-python", -- python debugger
                config = function()
                    require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
                end,
            },
            {
                "leoluz/nvim-dap-go",
                config = function()
                    require("dap-go").setup()
                end,
            },
            {
                "rcarriga/nvim-dap-ui", -- debugger UI
                config = function()
                    require("dapui").setup()
                end,
            },
            {
                "nvim-neotest/nvim-nio",
            },
            {
                "julianolf/nvim-dap-lldb",
                opts = { codelldb_path = "/sbin/codelldb" },
            },
        },
        config = function()
            local sign = vim.fn.sign_define

            sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
            sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
            sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
        end,
    },
}
