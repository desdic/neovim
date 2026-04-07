vim.pack.add({
    { src = "https://github.com/stevearc/conform.nvim" },
}, { confirm = false })

vim.defer_fn(function()
    require("conform").setup({
        formatters_by_ft = {
            c = { name = "clangd", timeout_ms = 500, lsp_format = "prefer" },
            cpp = { name = "clangd", timeout_ms = 500, lsp_format = "prefer" },
            go = { "golines", "goimports", "gofmt", "gofumpt" },
            json = { "jq" },
            lua = { "stylua" },
            python = { "isort", "black" },
            rust = { "rustfmt", lsp_format = "fallback" },
            sh = { "shfmt" },
            zig = { "zigfmt", lsp_format = "fallback" },
            glsl = { "clang-format" },
        },
    })
end, 500)
