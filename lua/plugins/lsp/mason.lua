return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    opts = {
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
            },
        },
    },
    config = function(_, opts)
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_tool_installer = require("mason-tool-installer")

        mason.setup(opts)

        mason_lspconfig.setup({
            ensure_installed = {
                "gopls",
                "lua_ls",
                "bashls",
                "yamlls",
                "pyright",
                "pylsp",
                "solargraph",
                "dockerls",
                "clangd",
                "jsonls",
                "perlnavigator",
                "rust_analyzer",
            },
            -- auto-install configured servers (with lspconfig)
            automatic_installation = true, -- not the same as ensure_installed
        })

        mason_tool_installer.setup({
            ensure_installed = {
                "stylua",
                "isort",
                "black",
                "mypy",
                "pylint",
                "ruff",
                "golines",
                "goimports",
                "golangci-lint",
                "gofumpt",
                "gci",
                "shellcheck",
            }
        })
    end
}
