return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                c = { name = "clangd", timeout_ms = 500, lsp_format = "prefer" },
                cpp = { name = "clangd", timeout_ms = 500, lsp_format = "prefer" },
                go = { "golines", "goimports", "gofmt", "gofumpt", "gci" },
                json = { "jq" },
                lua = { "stylua" },
                python = { "isort", "black" },
                rust = { "rustfmt", lsp_format = "fallback" },
                sh = { "shfmt" },
                zig = { "zigfmt", lsp_format = "fallback" },
            },
        })
    end,
}
