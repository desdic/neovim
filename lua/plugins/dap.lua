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
                dependencies = {
                    "nvim-neotest/nvim-nio",
                },
                config = function()
                    require("dapui").setup()
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
                "julianolf/nvim-dap-lldb",
                ft = { "c", "cpp", "rust", "zig" },
                opts = { codelldb_path = "/sbin/codelldb" },
            },
            {
                "jbyuki/one-small-step-for-vimkind",
                keys = {
                    {
                        "<leader>dl",
                        function()
                            require("osv").launch({ port = 8086 })
                        end,
                        desc = "Launch Lua adapter",
                    },
                },
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
