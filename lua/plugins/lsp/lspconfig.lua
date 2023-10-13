return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "stevearc/aerial.nvim",
    },
    config = function()
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local capabilities = cmp_nvim_lsp.default_capabilities()

        local on_attach = function(client, bufnr)
            -- Check for capabilities
            local has_cap = function(cap)
                return client.server_capabilities[cap .. "Provider"]
            end

            local has_plugin = function(plugin)
                return pcall(require, plugin)
            end

            require("core.format").on_attach(client, bufnr)

            local keymap = vim.keymap
            local format = require("core.format").format

            keymap.set(
                "n",
                "gl",
                vim.diagnostic.open_float,
                { silent = true, buffer = bufnr, desc = "Line diagnostics" }
            )
            keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", { silent = true, desc = "LSP info" })
            keymap.set("n", "<leader>cr", "<cmd>LspRestart<cr>", { silent = true, desc = "Restart LSP server" })
            keymap.set(
                "n",
                "<leader>xd",
                "<cmd>Telescope diagnostics<cr>",
                { silent = true, desc = "Telescope Diagnostics" }
            )
            keymap.set(
                "n",
                "gd",
                "<cmd>Telescope lsp_definitions<cr>",
                { silent = true, buffer = bufnr, desc = "Goto Definition" }
            )
            keymap.set(
                "n",
                "gr",
                "<cmd>Telescope lsp_references<cr>",
                { silent = true, buffer = bufnr, desc = "References" }
            )
            keymap.set(
                "n",
                "gi",
                "<cmd>Telescope lsp_implementations<cr>",
                { silent = true, buffer = bufnr, desc = "Goto Implementation" }
            )
            keymap.set(
                "n",
                "gt",
                "<cmd>Telescope lsp_type_definitions<cr>",
                { silent = true, buffer = bufnr, desc = "Goto Type Definition" }
            )
            keymap.set("n", "K", vim.lsp.buf.hover, { silent = true, buffer = bufnr, desc = "Hover" })

            keymap.set(
                "n",
                "<C-j>",
                vim.diagnostic.goto_next,
                { silent = true, buffer = bufnr, desc = "Next Diagnostic" }
            )
            keymap.set(
                "n",
                "<C-k>",
                vim.diagnostic.goto_prev,
                { silent = true, buffer = bufnr, desc = "Prev Diagnostic" }
            )


            if has_cap("signatureHelp") then
                keymap.set(
                    "n",
                    "gs",
                    vim.lsp.buf.signature_help,
                    { silent = true, buffer = bufnr, desc = "Signature Help" }
                )
            end

            if has_plugin("aerial") then
                keymap.set("n", "{", "<cmd>AerialNext<cr>", { silent = true, buffer = bufnr, desc = "Aerial next" })
                keymap.set("n", "}", "<cmd>AerialPrev<cr>", { silent = true, buffer = bufnr, desc = "Aerial prev" })
            end

            if not has_plugin("inc_rename") then
                if has_cap("rename") then
                    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
                end
            end

            if has_cap("codeAction") then
                keymap.set({ "n", "v" }, "<leader>ca", function()
                    if vim.bo.filetype == "go" then
                        if has_plugin("go") then
                            return vim.cmd("GoCodeAction")
                        end
                    end
                    return vim.lsp.buf.code_action()
                end, { silent = true, buffer = bufnr, desc = "Code Action" })
            end

            if has_cap("documentFormatting") then
                keymap.set("n", "<leader>f", format, { silent = true, buffer = bufnr, desc = "Format Document" })
            end

            if has_cap("documentRangeFormatting") then
                keymap.set("v", "<leader>f", format, { silent = true, buffer = bufnr, desc = "Format Range" })
            end
        end

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
