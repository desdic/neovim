return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "saghen/blink.cmp",

        {
            "folke/lazydev.nvim",
            ft = "lua", -- only load on lua files
            opts = {
                library = {
                    -- See the configuration section for more details
                    -- Load luvit types when the `vim.uv` word is found
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
    },
    config = function()
        local lspconfig = require("lspconfig")

        -- Go
        lspconfig.gopls.setup({})
        lspconfig.golangci_lint_ls.setup({})

        -- Python
        lspconfig.pyright.setup({})
        lspconfig.pylsp.setup({
            plugins = {
                rope_import = {
                    enabled = true,
                },
            },
        })
        lspconfig.ruff.setup({})

        lspconfig.lua_ls.setup({})
        lspconfig.bashls.setup({})
        lspconfig.clangd.setup({
            cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
                "--function-arg-placeholders",
                "--fallback-style=llvm",
            },
        })

        lspconfig.jsonls.setup({})
        lspconfig.yamlls.setup({})
        lspconfig.cmake.setup({})
        lspconfig.dockerls.setup({})
        lspconfig.zls.setup({})

        lspconfig.solargraph.setup({
            filetypes = { "ruby", "eruby", "rakefile" },
        })

        vim.diagnostic.config({
            -- disable virtual text
            virtual_text = false,
            -- show signs
            update_in_insert = true,
            underline = true,
            severity_sort = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "if_many",
                header = "",
                prefix = "",
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = " ",
                    [vim.diagnostic.severity.WARN] = " ",
                    [vim.diagnostic.severity.INFO] = " ",
                    [vim.diagnostic.severity.HINT] = "󰠠 ",
                },
                texthl = {
                    [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
                    [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
                    [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
                    [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
                },
                numhl = {
                    [vim.diagnostic.severity.ERROR] = "",
                    [vim.diagnostic.severity.WARN] = "",
                    [vim.diagnostic.severity.INFO] = "",
                    [vim.diagnostic.severity.HINT] = "",
                },
            },
        })

        vim.g.rustaceanvim = {
            tools = {},
            server = {
                on_attach = function(client, bufnr)
                    -- TODO: you can also put keymaps in here
                end,
                default_settings = {
                    ["rust-analyzer"] = {},
                },
            },
            -- DAP configuration
            dap = {},
        }

        require("lspconfig.ui.windows").default_options.border = "rounded"

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

        vim.lsp.handlers["textDocument/signatureHelp"] =
            vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
    end,
}
