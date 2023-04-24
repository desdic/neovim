return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                { "ray-x/lsp_signature.nvim" },
                { "hrsh7th/cmp-nvim-lsp" },
                {
                    "SmiteshP/nvim-navic",
                    opts = { highlight = true },
                    config = function(_, opts)
                        require("nvim-navic").setup(opts)
                    end,
                },
                { "williamboman/mason.nvim", cmd = "Mason", opts = {} },
                { "williamboman/mason-lspconfig.nvim" },
                {
                    "rust-lang/rust.vim",
                    ft = "rust",
                    init = function()
                        vim.g.rustfmt_autosave = 1
                    end,
                },
                { "RRethy/vim-illuminate" },
                {
                    "simrat39/rust-tools.nvim",
                    opts = {
                        tools = {
                            inlay_hints = {
                                auto = false,
                            },
                        },
                    },
                    config = function(_, opts)
                        require("rust-tools").setup(opts)
                    end,
                }
            },
        },
        opts = {
            servers = {
                gopls = {
                    settings = {
                        gopls = {
                            analyses = { unusedparams = true },
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
                    root_dir = function()
                        return vim.fs.dirname(vim.fs.find({ ".git", "go.mod", "." }, { upward = true })[1])
                    end,
                    init_options = { usePlaceholders = true, completeUnimported = true, gofumpt = true },
                },
                lua_ls = {
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
                },
                bashls = { filetypes = { "sh", "zsh" } },
                yamlls = {
                    settings = {
                        yaml = {
                            keyOrdering = false,
                        },
                    },
                },
                pyright = {
                    settings = {
                        python = {
                            analysis = {
                                autoSearchPaths = true,
                                diagnosticMode = "openFilesOnly",
                                useLibraryCodeForTypes = true,
                            },
                        },
                    },
                },
                pylsp = {},
                efm = {},
                solargraph = { filetypes = { "ruby", "rb", "erb", "rakefile" } },
                dockerls = { root_dir = vim.loop.cwd },
                clangd = { cmd = { "clangd", "--background-index" } },
                jsonls = {},
                perlnavigator = {},
            },
            setup = {},
            capabilities = { clangd = { offsetEncoding = { "utf-16" } } },
        },
        event = "BufReadPre",
        config = function(_, opts)
            local cmp_nvim_lsp = require("cmp_nvim_lsp")

            local on_attach = function(client, bufnr)
                require("plugins.lsp.format").on_attach(client, bufnr)

                -- Avoid attaching multiple times
                if client.name ~= "pylsp" and client.name ~= "null-ls" and client.name ~= "efm" then
                    require("nvim-navic").attach(client, bufnr)
                end

                -- require("lsp-inlayhints").on_attach(client, bufnr)
                require("plugins.lsp.keymaps").on_attach(client, bufnr)
            end

            local servers = opts.servers
            local capabilities = cmp_nvim_lsp.default_capabilities()

            require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })
            require("mason-lspconfig").setup_handlers({
                function(server)
                    local server_opts = servers[server] or {}
                    server_opts.capabilities = capabilities

                    if opts.capabilities[server] then
                        for k, v in pairs(opts.capabilities[server]) do
                            server_opts.capabilities[k] = v
                        end
                    end

                    server_opts.on_attach = on_attach
                    if opts.setup[server] then
                        if opts.setup[server](server, server_opts) then
                            return
                        end
                    elseif opts.setup["*"] then
                        if opts.setup["*"](server, server_opts) then
                            return
                        end
                    end
                    require("lspconfig")[server].setup(server_opts)
                end,
            })

            local rt = require("rust-tools")
            local rust_opts = {
                server = {
                    on_attach = function(client, bufnr)
                        -- Code action groups
                        vim.keymap.set("n", "<Leader>ca", rt.code_action_group.code_action_group, { buffer = bufnr })
                        require("illuminate").on_attach(client)
                    end,
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
            }

            rt.setup(rust_opts)

            local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
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
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        build = {
            "go install github.com/daixiang0/gci@latest",
            "go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest",
            "go install golang.org/x/tools/cmd/goimports@latest",
        },
        dependencies = { "jayp0521/mason-null-ls.nvim" },
        event = "BufReadPre",
        config = function()
            require("mason-null-ls").setup({
                -- list of formatters & linters for mason to install
                ensure_installed = { "stylua", "black", "goimports", "golangci_lint" },
                -- auto-install configured servers (with lspconfig)
                automatic_installation = true,
            })

            local null_ls = require("null-ls")
            local h = require("null-ls.helpers")

            -- for conciseness
            local formatting = null_ls.builtins.formatting -- to setup formatters
            local diagnostics = null_ls.builtins.diagnostics -- to setup linters

            local gci_format = {
                method = null_ls.methods.FORMATTING,
                filetypes = { "go" },
                generator = h.formatter_factory({ command = "gci", args = { "-w", "$FILENAME" }, to_temp_file = true }),
            }

            -- configure null_ls
            null_ls.setup({
                -- setup formatters & linters
                sources = {
                    formatting.stylua,
                    formatting.black,
                    formatting.rustfmt,
                    formatting.gofmt,
                    formatting.gofumpt,
                    formatting.clang_format,
                    formatting.goimports,
                    diagnostics.golangci_lint.with({
                        args = {
                            "run",
                            "--enable-all",
                            "--disable",
                            "lll",
                            "--disable",
                            "godot",
                            "--out-format=json",
                            "$DIRNAME",
                            "--path-prefix",
                            "$ROOT",
                        },
                    }),
                    gci_format,
                    null_ls.builtins.formatting.rubocop.with({
                        args = {
                            "--auto-correct",
                            "-f",
                            "-c",
                            HOME_PATH .. "/.work-rubocop.yml",
                            "quiet",
                            "--stderr",
                            "--stdin",
                            "$FILENAME",
                        },
                    }),
                    null_ls.builtins.diagnostics.rubocop.with({
                        args = { "-c", HOME_PATH .. "/.work-rubocop.yml", "-f", "json", "--stdin", "$FILENAME" },
                    }),
                },
            })
        end,
    },
}
