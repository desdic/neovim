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
            },
        })

        vim.keymap.set({ "n", "v" }, "<leader>f", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            })
        end, { desc = "Format file or range (in visual mode)" })
    end,
}
