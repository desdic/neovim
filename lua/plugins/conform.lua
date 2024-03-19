return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                json = { "jq" },
                lua = { "stylua" },
                python = { "isort", "black" },
                go = { "golines", "goimports", "gofmt", "gofumpt", "gci" },
                rust = { "rustfmt" },
                sh = { "shfmt" },
                c = { "clang-format" },
                cpp = { "clang-format" },
            },
        })
    end,
}
