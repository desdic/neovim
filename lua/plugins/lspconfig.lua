return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "saghen/blink.cmp",
    },
    cmd = { "MasonUpdate", "Mason" },
    config = function()
        local lspconfig = require("lspconfig")
        local capabilities = require("blink.cmp").get_lsp_capabilities()

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
                "cmake",
                "dockerls",
                "glsl_analyzer",
                "gopls",
                "jsonls",
                "lua_ls",
                "perlnavigator",
                "pylsp",
                "pyright",
                "solargraph",
                "yamlls",
                "zls",
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
                -- ["lua_ls"] = function()
                --     lspconfig.lua_ls.setup({
                --
                --         on_init = function(client)
                --             if client.workspace_folders then
                --                 local path = client.workspace_folders[1].name
                --                 if
                --                     vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc")
                --                 then
                --                     return
                --                 end
                --             end
                --
                --             client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                --                 runtime = {
                --                     -- Tell the language server which version of Lua you're using
                --                     -- (most likely LuaJIT in the case of Neovim)
                --                     version = "LuaJIT",
                --                 },
                --                 -- Make the server aware of Neovim runtime files
                --                 workspace = {
                --                     checkThirdParty = false,
                --                     library = {
                --                         vim.env.VIMRUNTIME,
                --                     },
                --                 },
                --             })
                --         end,
                --         filetypes = { "lua" },
                --         settings = { -- custom settings for lua
                --             Lua = {
                --                 -- make the language server recognize "vim" global
                --                 diagnostics = { globals = { "vim", "require" } },
                --                 completion = {
                --                     callSnippet = "Replace",
                --                 },
                --                 workspace = {
                --                     -- make language server aware of runtime files
                --                     library = {
                --                         [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                --                         [vim.fn.stdpath("config") .. "/lua"] = true,
                --                     },
                --                 },
                --                 hint = {
                --                     enable = true,
                --                 },
                --             },
                --         },
                --     })
                -- end,

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

                                codelenses = {
                                    generate = true,
                                    gc_details = true,
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

                -- {{ Disable rust in LSP since its handled by rustaceanvim
                ["rust_analyzer"] = function() end,

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

                ["cmake"] = function()
                    lspconfig["cmake"].setup({})
                end,

                -- {{ C/C++
                ["clangd"] = function()
                    lspconfig["clangd"].setup({
                        root_dir = function(fname)
                            return require("lspconfig.util").root_pattern(
                                "Makefile",
                                "configure.ac",
                                "configure.in",
                                "config.h.in",
                                "meson.build",
                                "meson_options.txt",
                                "build.ninja"
                            )(fname) or require("lspconfig.util").root_pattern(
                                "compile_commands.json",
                                "compile_flags.txt"
                            )(fname) or require("lspconfig.util").find_git_ancestor(fname)
                        end,
                        cmd = {
                            "clangd",
                            "--background-index",
                            "--clang-tidy",
                            "--header-insertion=iwyu",
                            "--completion-style=detailed",
                            "--function-arg-placeholders",
                            "--fallback-style=llvm",
                        },
                        capabilities = {
                            offsetEncoding = { "utf-16" },
                        },
                        init_options = {
                            usePlaceholders = true,
                            completeUnimported = true,
                            clangdFileStatus = true,
                        },
                    })
                end,
            },
        })

        mason_tool_installer.setup({
            ensure_installed = {
                "black",
                "cmakelint",
                "gci",
                "gofumpt",
                "goimports",
                "golangci-lint",
                "golines",
                "isort",
                -- "mypy",
                "pylint",
                "ruff",
                "shellcheck",
                "shfmt",
                "stylua",
            },
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
