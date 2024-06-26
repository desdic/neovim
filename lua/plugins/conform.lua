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
                sh = { "shfmt" },
                c = { "clang-format" },
                cpp = { "clang-format" },
                zig = { "zigfmt" },
            },
        })
    end,
}
