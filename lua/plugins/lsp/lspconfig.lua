return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "SmiteshP/nvim-navic",
    },
    config = function()
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local on_attach = function(client, bufnr)
            require("core.format").on_attach(client, bufnr)

            if client.server_capabilities.documentSymbolProvider then
                -- Avoid attching to pyright and pylsp
                if client.name ~= "pylsp" then
                    require("nvim-navic").attach(client, bufnr)
                end
            end

            require("core.keymaps_lsp").on_attach(client, bufnr)
        end

        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- {{{ Lua
        lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
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
        -- }}}

        -- {{{ Go
        lspconfig["gopls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
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
                return vim.fs.dirname(vim.fs.find({ ".git", "go.mod", "go.work", "." }, { upward = true })[1])
            end,
        })
        -- }}}

        -- {{{ Python
        lspconfig["pyright"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["pylsp"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            plugins = {
                rope_import = {
                    enabled = true,
                },
            },
        })
        -- }}}

        -- {{{ Json
        lspconfig["jsonls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            on_new_config = function(new_config)
                new_config.settings.json.schemas = new_config.settings.json.schemas or {}
                vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
            end,
        })
        -- }}}

        -- {{{ Yaml
        lspconfig["yamlls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                yaml = {
                    keyOrdering = false,
                },
            },
        })
        -- }}}

        -- {{{ Shell
        lspconfig["bashls"].setup({
            filetypes = { "sh", "zsh" },
            capabilities = capabilities,
            on_attach = on_attach,
        })
        -- }}}

        -- {{{ Ruby
        lspconfig["solargraph"].setup({
            filetypes = { "ruby", "rb", "erb", "rakefile" },
            capabilities = capabilities,
            on_attach = on_attach,
        })
        -- }}}

        -- {{{ Docker
        lspconfig["dockerls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            root_dir = vim.loop.cwd,
        })
        -- }}}

        -- {{{ Perl
        lspconfig["perlnavigator"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })
        -- }}}

        -- {{{ C
        local clangcapabilities = capabilities
        clangcapabilities["offsetEncoding"] = { "utf-16" }
        clangcapabilities["signatureHelpProvider"] = false

        lspconfig["clangd"].setup({
            capabilities = clangcapabilities,
            on_attach = on_attach,
            cmd = { "clangd", "--background-index" },
        })
        -- }}}

        -- {{{ Rust
        local rt = require("rust-tools")
        rt.setup({
            server = {
                on_attach = on_attach,
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                        },
                        checkOnSave = {
                            command = "clippy",
                        },
                    },
                },
            },
            tools = {
                inlay_hints = {
                    auto = false,
                },
            },
        })
        -- }}}

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

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

        vim.lsp.handlers["textDocument/signatureHelp"] =
            vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
    end,
}
