return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        build = {
            "go install github.com/daixiang0/gci@latest",
            "go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest",
            "go install golang.org/x/tools/cmd/goimports@latest",
        },
        dependencies = {
            {
                { "ray-x/lsp_signature.nvim" },
                { "hrsh7th/cmp-nvim-lsp" },
                {
                    "SmiteshP/nvim-navic",
                    opts = {
                        highlight = true,
                        depth_limit = 5,
                    },
                    config = function(_, opts)
                        require("nvim-navic").setup(opts)
                    end,
                },
                {
                    "williamboman/mason.nvim",
                    cmd = "Mason",
                    build = ":MasonUpdate", -- :MasonUpdate updates registry contents
                    opts = {}
                },
                { "williamboman/mason-lspconfig.nvim" },
                {
                    "rust-lang/rust.vim",
                    ft = "rust",
                    init = function()
                        vim.g.rustfmt_autosave = 1
                    end,
                },
                {
                    "simrat39/rust-tools.nvim",
                    ft = "rust",
                },
                {
                    "b0o/schemastore.nvim",
                    version = false, -- last release is way too old
                },
            },
        },
        opts = {
            servers = {
                gopls = {
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
                },
                lua_ls = {
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
                },
                bashls = { filetypes = { "sh", "zsh" } },
                yamlls = {
                    filetypes = { "yaml" },
                    settings = {
                        yaml = {
                            keyOrdering = false,
                        },
                    },
                },
                pyright = {
                    filetypes = { "python" },
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
                pylsp = {
                    plugins = {
                        rope_import = {
                            enabled = true,
                        },
                    },
                    filetypes = { "python" },
                },
                efm = { -- https://github.com/lukas-reineke/dotfiles/tree/89d8a6331b51940a6c457b4b1422c9421c269150/vim/lua/efm
                    init_options = { documentFormatting = true },
                    filetypes = { "lua", "rust", "go", "c", "python", "make", "markdown", "json", "sh", "yaml" },
                    settings = {
                        rootMarkers = { ".git/" },
                        languages = {
                            lua = {
                                {
                                    formatCommand =
                                    "/home/kgn/.local/share/nvim/mason/bin/stylua --stdin-filepath ${INPUT}",
                                    formatStdin = true,
                                },
                            },
                            python = {
                                {
                                    formatCommand =
                                    "/home/kgn/.local/share/nvim/mason/bin/black --fast ${-l:lineLength} -",
                                    formatStdin = true,
                                },
                                {
                                    lintCommand =
                                    "/home/kgn/.local/share/nvim/mason/bin/ruff -n -e --stdin-filename ${INPUT} -",
                                    lintFormats = {
                                        "%f:%l:%c: %m",
                                    },
                                    lintStdin = true,
                                },
                                {
                                    lintCommand =
                                    "/home/kgn/.local/share/nvim/mason/bin/mypy --show-column-numbers --ignore-missing-imports --show-error-codes",
                                    lintFormats = {
                                        "%f:%l:%c: %trror: %m",
                                        "%f:%l:%c: %tarning: %m",
                                        "%f:%l:%c: %tote: %m",
                                    },
                                    lintSource = "mypy",
                                },
                                -- {
                                --     formatCommand = "isort --stdout ${-l:lineLength} --profile black -",
                                --     formatStdin = true,
                                -- },
                            },
                            go = {
                                {
                                    formatCommand = "/home/kgn/.local/share/nvim/mason/bin/goimports",
                                    formatStdin = true,
                                },
                                {
                                    formatCommand = "/home/kgn/.local/share/nvim/mason/bin/golines",
                                    formatStdin = true,
                                },
                                {
                                    formatCommand = "gofmt",
                                    formatStdin = true,
                                },
                                {
                                    formatCommand = "gofumpt",
                                    formatStdin = true,
                                },
                                {
                                    formatCommand = "gci ${INPUT}",
                                    formatStdin = true,
                                },
                                {
                                    lintCommand =
                                    "golangci-lint run --enable-all --disable lll --out-format=line-number ${INPUT}",
                                    lintFormats = {
                                        "%f:%l:%c: %m",
                                    },
                                }
                            },
                            rust = {
                                {
                                    formatCommand = "rustfmt",
                                    formatStdin = true,
                                },
                            },
                            make = {
                                {
                                    lintCommand = "checkmake",
                                    lintStdin = true,
                                    lintSource = "checkmake"
                                }
                            },
                            sh = {

                                {
                                    lintCommand = "shellcheck -f gcc -x",
                                    lintSource = "shellcheck",
                                    lintFormats = {
                                        "%f:%l:%c: %trror: %m",
                                        "%f:%l:%c: %tarning: %m",
                                        "%f:%l:%c: %tote: %m",
                                    }

                                },
                                {
                                    formatCommand = "shfmt -ci -s -bn",
                                    formatStdin = true
                                }
                            },
                            json = {
                                {
                                    lintCommand = "jq ."
                                }
                            }
                            -- c = {
                            --     {
                            --         formatCommand = "clang-format -assume-filename ${INPUT} --offset --length",
                            --         formatStdin = true,
                            --         -- formatOffsetColumns = 1 ?
                            --     }
                            -- }
                        },
                    },
                },
                solargraph = { filetypes = { "ruby", "rb", "erb", "rakefile" } },
                dockerls = { root_dir = vim.loop.cwd },
                clangd = { cmd = { "clangd", "--background-index" } },
                jsonls = {
                    on_new_config = function(new_config)
                        new_config.settings.json.schemas = new_config.settings.json.schemas or {}
                        vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
                    end,
                },
                perlnavigator = {},
                rust_analyzer = {
                    disabled = true, -- just make sure its installed
                },
                rust_tools = {
                    server = {
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
                },
            },
            setup = {
                clangd = function(_, server_opts)
                    server_opts["capabilities"]["offsetEncoding"] = { "utf-16" }
                    server_opts["capabilities"]["signatureHelpProvider"] = false
                end,
                rust_tools = function(_, server_opts)
                    require("rust-tools").setup(server_opts)
                end,
            },
        },
        config = function(_, opts)
            local cmp_nvim_lsp = require("cmp_nvim_lsp")

            local on_attach = function(client, bufnr)
                require("plugins.lsp.format").on_attach(client, bufnr)

                -- Avoid attaching multiple times
                if client.name ~= "pylsp" and client.name ~= "null-ls" and client.name ~= "efm" then
                    require("nvim-navic").attach(client, bufnr)
                end

                require("plugins.lsp.keymaps").on_attach(client, bufnr)
            end

            local servers = opts.servers
            local capabilities = cmp_nvim_lsp.default_capabilities()

            -- get all the servers that are available thourgh mason-lspconfig
            local have_mason, mlsp = pcall(require, "mason-lspconfig")
            local all_mslp_servers = {}
            if have_mason then
                all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
            end

            local ensure_installed = {}
            local not_supported = {}
            for server, _ in pairs(servers) do
                if vim.tbl_contains(all_mslp_servers, server) then
                    table.insert(ensure_installed, server)
                else
                    table.insert(not_supported, server)
                end
            end

            local function setup_handler(server)
                local server_opts = servers[server] or {}
                server_opts.capabilities = capabilities

                -- if disabled we install it but don't configure it
                local disabled = server_opts["disabled"] or false
                if disabled then
                    return
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
            end

            mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup_handler } })

            -- Setup unsupported language servers
            for _, server in ipairs(not_supported) do
                local server_opts = servers[server] or {}
                server_opts.capabilities = capabilities
                server_opts.on_attach = on_attach
                if opts.setup[server] then
                    opts.setup[server](server, server_opts)
                end
            end

            local signs = { Error = " ", Warn = " ", Hint = "󰵚 ", Info = " " }
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
            --
            vim.lsp.handlers["textDocument/signatureHelp"] =
                vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
        end,
    },
    {
        "jayp0521/mason-null-ls.nvim", -- use mason-null-ls to install stuff needed for efm
        dependencies = { "jose-elias-alvarez/null-ls.nvim" },
        config = function()
            require("mason-null-ls").setup({
                -- list of formatters & linters for mason to install
                ensure_installed = { "stylua", "black", "goimports", "golines", "golangci_lint", "ruff", "mypy",
                    "clang-format" },
                -- auto-install configured servers (with lspconfig)
                automatic_installation = true,
            })
            local null_ls = require("null-ls")
            null_ls.setup({})
        end
    }
    -- {
    --     "jose-elias-alvarez/null-ls.nvim",
    --     dependencies = { "jayp0521/mason-null-ls.nvim" },
    --     event = { "BufReadPre", "BufNewFile" },
    --     config = function()
    --         require("mason-null-ls").setup({
    --             -- list of formatters & linters for mason to install
    --             ensure_installed = { "stylua", "black", "goimports", "golines", "golangci_lint", "ruff", "mypy" },
    --             -- auto-install configured servers (with lspconfig)
    --             automatic_installation = true,
    --         })
    --
    --         local null_ls = require("null-ls")
    --         -- local h = require("null-ls.helpers")
    --
    --         -- for conciseness
    --         -- local formatting = null_ls.builtins.formatting -- to setup formatters
    --         local diagnostics = null_ls.builtins.diagnostics -- to setup linters
    --
    --         -- local gci_format = {
    --         --     method = null_ls.methods.FORMATTING,
    --         --     filetypes = { "go" },
    --         --     generator = h.formatter_factory({ command = "gci", args = { "-w", "$FILENAME" }, to_temp_file = true }),
    --         -- }
    --
    --         -- configure null_ls
    --         null_ls.setup({
    --             -- setup formatters & linters
    --             sources = {
    --                 -- formatting.stylua,
    --                 -- formatting.black,
    --                 -- formatting.rustfmt,
    --                 -- formatting.gofmt,
    --                 -- formatting.gofumpt,
    --                 -- formatting.clang_format,
    --                 -- formatting.goimports,
    --                 -- diagnostics.mypy,
    --                 -- diagnostics.ruff,
    --                 -- formatting.golines,
    --                 diagnostics.golangci_lint.with({
    --                     args = {
    --                         "run",
    --                         "--enable-all",
    --                         "--disable",
    --                         "lll",
    --                         "--disable",
    --                         "godot",
    --                         "--disable",
    --                         "goimports",
    --                         "--out-format=json",
    --                         "$DIRNAME",
    --                         "--path-prefix",
    --                         "$ROOT",
    --                     },
    --                 }),
    --                 -- gci_format,
    --                 -- null_ls.builtins.formatting.rubocop.with({
    --                 --     args = {
    --                 --         "--auto-correct",
    --                 --         "-f",
    --                 --         "-c",
    --                 --         HOME_PATH .. "/.work-rubocop.yml",
    --                 --         "quiet",
    --                 --         "--stderr",
    --                 --         "--stdin",
    --                 --         "$FILENAME",
    --                 --     },
    --                 -- }),
    --                 -- null_ls.builtins.diagnostics.rubocop.with({
    --                 --     args = { "-c", HOME_PATH .. "/.work-rubocop.yml", "-f", "json", "--stdin", "$FILENAME" },
    --                 -- }),
    --             },
    --         })
    --     end,
    -- },
}
