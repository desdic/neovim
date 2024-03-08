return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },
    cmd = {"MasonUpdate", "Mason"},
    config = function()
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- To avoid getting warning on using multiple encodings
        local clangcapabilities = capabilities
        clangcapabilities["offsetEncoding"] = { "utf-16" }
        clangcapabilities["signatureHelpProvider"] = false

        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_tool_installer = require("mason-tool-installer")

        mason.setup({
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        mason_lspconfig.setup({
            ensure_installed = {
                "bashls",
                "clangd",
                "dockerls",
                "gopls",
                "jsonls",
                "lua_ls",
                "perlnavigator",
                "pylsp",
                "pyright",
                "rust_analyzer",
                "solargraph",
                "yamlls",
            },
            -- auto-install configured servers (with lspconfig)
            automatic_installation = true, -- not the same as ensure_installed
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                    })
                end,

                -- Extra settings for LSP

                -- {{ LUA
                ["lua_ls"] = function()
                    lspconfig.lua_ls.setup({
                        filetypes = { "lua" },
                        settings = { -- custom settings for lua
                            Lua = {
                                -- make the language server recognize "vim" global
                                diagnostics = { globals = { "vim", "require" } },
                                workspace = {
                                    -- make language server aware of runtime files
                                    library = {
                                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                        [vim.fn.stdpath("config") .. "/lua"] = true,
                                    },
                                },
                                hint = {
                                    enable = true,
                                },
                            },
                        },
                    })
                end,

                -- {{ Go
                ["gopls"] = function()
                    lspconfig["gopls"].setup({
                        settings = {
                            gopls = {
                                usePlaceholders = true,
                                completeUnimported = true,
                                analyses = {
                                    nilness = true,
                                    unusedparams = true,
                                    unusedwrite = true,
                                    useany = true,
                                },
                                staticcheck = true,
                                gofumpt = true,

                                hints = {
                                    assignVariableTypes = true,
                                    compositeLiteralFields = true,
                                    compositeLiteralTypes = true,
                                    constantValues = true,
                                    functionTypeParameters = true,
                                    parameterNames = true,
                                    rangeVariableTypes = true,
                                },
                            },
                        },
                        filetypes = { "go", "gomod", "gowork", "gotmpl" },
                        root_dir = function()
                            return vim.fs.dirname(
                                vim.fs.find({ ".git", "go.mod", "go.work", "." }, { upward = true })[1]
                            )
                        end,
                    })
                end,

                -- {{ Python
                ["pylsp"] = function()
                    lspconfig["pylsp"].setup({
                        plugins = {
                            rope_import = {
                                enabled = true,
                            },
                        },
                    })
                end,

                -- {{ JSON
                ["jsonls"] = function()
                    lspconfig["jsonls"].setup({
                        settings = {
                            settings = {
                                json = {
                                    schemas = require("schemastore").json.schemas(),
                                    validate = { enable = true },
                                },
                            },
                        },
                    })
                end,

                -- {{ YAML
                ["yamlls"] = function()
                    lspconfig["yamlls"].setup({
                        settings = {
                            yaml = {
                                keyOrdering = false,
                                schemaStore = {
                                    -- You must disable built-in schemaStore support if you want to use
                                    -- this plugin and its advanced options like `ignore`.
                                    enable = false,
                                    -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                                    url = "",
                                },
                                schemas = require("schemastore").yaml.schemas(),
                            },
                        },
                    })
                end,

                -- {{ Ruby
                ["solargraph"] = function()
                    lspconfig["solargraph"].setup({
                        filetypes = { "ruby", "eruby", "rakefile" },
                    })
                end,

                -- {{ C/C++
                ["clangd"] = function()
                    lspconfig["clangd"].setup({
                        cmd = { "clangd", "--background-index" },
                        capabilities = clangcapabilities
                    })
                end,
            },
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
            },
        })

        vim.g.rustaceanvim = {
            -- Plugin configuration
            tools = {},
            -- LSP configuration
            server = {
                settings = {
                    -- rust-analyzer language server configuration
                    ["rust-analyzer"] = {},
                },
            },
            -- DAP configuration
            dap = {},
        }

        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        vim.diagnostic.config({
            -- disable virtual text
            virtual_text = false,
            -- show signs
            signs = { active = signs },
            update_in_insert = true,
            underline = true,
            severity_sort = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        require("lspconfig.ui.windows").default_options.border = "rounded"

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

        vim.lsp.handlers["textDocument/signatureHelp"] =
            vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
    end,
}