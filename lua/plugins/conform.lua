vim.pack.add({
    { src = "https://github.com/stevearc/conform.nvim", load = false },
}, { confirm = false })

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "go", "gomod", "gosum", "c", "cpp", "json", "python", "cmake", "rust", "lua", "glsl" },
    callback = function(event)
        if vim.g.conform_nvim_loaded then
            return
        end

        vim.cmd("packadd nvim-lint")
        require("conform").setup({
            formatters_by_ft = {
                c = { name = "clangd", timeout_ms = 500, lsp_format = "prefer" },
                cpp = { name = "clangd", timeout_ms = 500, lsp_format = "prefer" },
                go = { "goimports", "gofmt", "gofumpt" },
                json = { "jq" },
                lua = { "stylua" },
                python = { "isort", "black" },
                rust = { "rustfmt", lsp_format = "fallback" },
                sh = { "shfmt" },
                glsl = { "clang-format" },
            },
        })

        vim.g.conform_nvim_loaded = true
    end,
})
