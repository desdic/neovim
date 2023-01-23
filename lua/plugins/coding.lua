return {
    {
        "L3MON4D3/LuaSnip", -- snippet completions
        dependencies = {
            "rafamadriz/friendly-snippets", -- collection of snippets
            config = function() require("luasnip.loaders.from_vscode").lazy_load() end
        },
        config = function()
            local ls = require("luasnip")
            local lsloader = require("luasnip.loaders.from_lua")

            lsloader.load({paths = "~/.config/nvim/snippets"})

            local types = require("luasnip.util.types")

            ls.config.set_config({
                -- Keep last snippet to jump around
                history = true,

                -- Enable dynamic snippets
                updateevents = "TextChanged,TextChangedI",

                enable_autosnippets = true,

                ext_opts = {
                    -- [types.insertNode] = {active = {virt_text = {{"●", "DiffAdd"}}}},
                    [types.choiceNode] = {active = {virt_text = {{"●", "Operator"}}}}
                }
            })

            -- Extend changelog with debchangelog
            ls.filetype_extend("changelog", {"debchangelog"})

            vim.keymap.set({"i", "s"}, "<c-j>", function()
                if ls.expand_or_jumpable() then ls.expand_or_jump() end
            end, {silent = true})

            vim.keymap.set({"i", "s"}, "<c-k>", function() if ls.jumpable(-1) then ls.jump(-1) end end, {silent = true})

            vim.keymap.set("i", "<c-l>", function() if ls.choice_active() then ls.change_choice(1) end end)
        end
    }, {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-nvim-lua", "hrsh7th/cmp-path",
            "hrsh7th/cmp-path", "onsails/lspkind-nvim", "saadparwaiz1/cmp_luasnip", "L3MON4D3/LuaSnip"
        },
        config = function()
            local cmp = require("cmp")
            local cmplsp = require("cmp_nvim_lsp")
            local compare = require("cmp.config.compare")
            local lspkind = require("lspkind")
            local luasnip = require("luasnip")

            cmplsp.setup()

            cmp.setup({
                preselect = false,
                snippet = {expand = function(args) luasnip.lsp_expand(args.body) end},
                formatting = {
                    fields = {cmp.ItemField.Kind, cmp.ItemField.Abbr, cmp.ItemField.Menu},
                    format = lspkind.cmp_format({maxwidth = 50, ellipsis_char = "..."})
                },
                sorting = {
                    priority_weight = 1.0,
                    comparators = {
                        compare.scopes, compare.offset, compare.exact, compare.score, compare.recently_used,
                        compare.locality, compare.kind, -- compare.sort_text,
                        compare.length, compare.order
                    }
                },
                min_length = 0, -- allow for `from package import _` in Python
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<C-y>"] = cmp.config.disable,
                    ["<CR>"] = cmp.mapping.confirm({select = false}), -- no not select first item

                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, {"i", "s"}),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, {"i", "s"})
                }),
                sources = {
                    {name = "nvim_lsp", priority = 10, keyword_length = 2},
                    {name = "buffer", priority = 8, keyword_length = 2},
                    {name = "luasnip", priority = 6, keyword_length = 2},
                    {name = "nvim_lua", priority_weight = 4, keyword_length = 2},
                    {name = "path", priority = 2, keyword_length = 2}
                },
                window = {documentation = cmp.config.window.bordered(), completion = cmp.config.window.bordered()}
            })
        end
    }, {
        "windwp/nvim-autopairs",
        event = "VeryLazy",
        opts = {
            disable_filetype = {"TelescopePrompt", "vim"},
            check_ts = true,
            ts_config = {
                lua = {"string"} -- it will not add a pair on that treesitter node
            }
        },
        config = function(_, opts)
            require("nvim-autopairs").setup(opts)
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end
    }, {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        dependencies = {"JoosepAlviste/nvim-ts-context-commentstring"},
        config = function()
            require("mini.comment").setup({
                hooks = {pre = function()
                    require("ts_context_commentstring.internal").update_commentstring({})
                end}
            })
        end
    }, -- pairs
    -- {"echasnovski/mini.pairs", event = "VeryLazy", config = function() require("mini.pairs").setup({}) end},
    -- surround
    {
        "echasnovski/mini.surround",
        event = "VeryLazy",
        config = function()
            require("mini.surround").setup({
                mappings = {
                    add = "gza", -- Add surrounding in Normal and Visual modes
                    delete = "gzd", -- Delete surrounding
                    find = "gzf", -- Find surrounding (to the right)
                    find_left = "gzF", -- Find surrounding (to the left)
                    highlight = "gzh", -- Highlight surrounding
                    replace = "gzr", -- Replace surrounding
                    update_n_lines = "gzn" -- Update `n_lines`
                }
            })
        end
    }, {
        "desdic/greyjoy.nvim",
        keys = {
            {"<Leader>gr", ":Greyjoy<CR>", desc = "[G]reyjoy [r]un"},
            {"<Leader>gf", ":Greyjoy fast<CR>", desc = "[G]reyjoy run [f]ast"}
        },
        config = function()
            local greyjoy = require("greyjoy")
            greyjoy.setup({
                output_results = "toggleterm",
                last_first = true,
                extensions = {
                    generic = {
                        commands = {
                            ["run {filename}"] = {command = {"python3", "{filename}"}, filetype = "python"},
                            ["run main.go"] = {
                                command = {"go", "run", "main.go"},
                                filetype = "go",
                                filename = "main.go"
                            },
                            ["build main.go"] = {
                                command = {"go", "build", "main.go"},
                                filetype = "go",
                                filename = "main.go"
                            }
                        }
                    },
                    kitchen = {targets = {"converge", "verify", "destroy", "test"}, include_all = false}
                },
                run_groups = {fast = {"generic", "makefile", "cargo"}}
            })

            greyjoy.load_extension("kitchen")
            greyjoy.load_extension("generic")
            -- greyjoy.load_extension("vscode_tasks")
            greyjoy.load_extension("makefile")
            greyjoy.load_extension("cargo")
        end
    }, {
        "ziontee113/neo-minimap",
        ft = {"go", "lua", "python", "cpp", "c", "markdown", "yaml", "rust"},
        config = function()
            local nm = require("neo-minimap")

            local winwidth = math.floor(vim.o.columns * 0.75)
            nm.setup_defaults({width = winwidth, height_toggle = {12, 36, 48}, hl_group = "DiagnosticWarn"})

            nm.source_on_save("~/.config/nvim/lua/plugins/neo-minimap.lua")

            -- Yaml
            nm.set({"zi", "zo", "zu"}, {"docker-compose*.yml"}, {
                events = {"BufEnter"},

                query = {
                    [[
        ;; query for finding names of containers
        (
            block_mapping (
                block_mapping_pair
                    key: ( flow_node( plain_scalar(string_scalar)))
                    value: (block_node(
                        block_mapping (
                            block_mapping_pair
                                key: ( flow_node( plain_scalar(string_scalar) @cap (#not-eq? @cap "build") ))
                                value: (block_node(
                                    block_mapping(block_mapping_pair key: ( flow_node( plain_scalar(string_scalar))))
                                )
                            )
                        )
                    )
                )
            )
        )
    ]], [[
        ;; query for functions/function declarations
        ((comment) @cap)
    ]], 1
                },

                -- auto_jump = false,
                -- open_win_opts = { border = "double" },
                win_opts = {scrolloff = 1},

                disable_indentation = true
            })

            -- Markdown
            nm.set({"zi", "zo", "zu"}, {"*.md"}, {
                events = {"BufEnter"},

                query = {
                    [[
        ;; query for functions/function declarations
        ((atx_heading) @cap)
    ]], [[
        ;; query for functions/function declarations
        ((fenced_code_block) @cap)
    ]], 1
                },

                -- auto_jump = false,
                -- open_win_opts = { border = "double" },
                win_opts = {scrolloff = 1},

                disable_indentation = true
            })

            -- Python
            nm.set({"zi", "zo", "zu"}, {"*.py"}, {
                events = {"BufEnter"},

                query = {
                    [[
        ;; query for functions/function declarations
        ((function_definition) @cap)
    ]], [[
        ;; query for comments
        ((identifier) @cap (#eq? @cap "{cursorword}"))
    ]], [[
        ;; query for structs /classes
        ((class_definition) @cap)
        ]], [[
        ;; query for function calls
        (call function: (identifier) @cap)
        ]]
                },

                -- auto_jump = false,
                -- open_win_opts = { border = "double" },
                win_opts = {scrolloff = 1},

                disable_indentation = true
            })

            -- C/CPP
            nm.set({"zi", "zo", "zu"}, {"*.c", "*.h", "*.hpp", "*.cpp", "*.cc", "*.frag", "*.vert"}, {
                events = {"BufEnter"},

                query = {
                    [[
        ;; query for functions/function declarations
        ((function_definition) @cap)
        (declaration declarator: (function_declarator)) @cap
    ]], [[
        ((identifier) @cap (#eq? @cap "{cursorword}"))
    ]], [[
        ;; query for structs /classes
        ((struct_specifier) @cap)
        ((class_specifier) @cap)
        ]], [[
        ;; query for function calls
        (call_expression function: (identifier) @cap)
        ]]
                },

                search_patterns = {
                    {"void", "<C-j>", true}, {"void", "<C-k>", false}
                    -- {"keymap", "<A-j>", true}, {"keymap", "<A-k>", false}
                },

                -- auto_jump = false,
                -- open_win_opts = { border = "double" },
                win_opts = {scrolloff = 1},

                disable_indentation = true
            })

            -- Go
            nm.set({"zi", "zo", "zu"}, "*.go", {
                events = {"BufEnter"},
                -- ((function_call (dot_index_expression) @field (#eq? @field "vim.keymap.set")) @cap)
                query = {
                    [[
        ;; query
        ((method_declaration) @cap)
        ((function_declaration) @cap)
        (call_expression function: (func_literal) @cap)
        ;;(method_declaration name: (field_identifier) @name (#eq? @name "{cursorword}")) @cap
    ]], [[
        ((identifier) @cap (#eq? @cap "{cursorword}"))
    ]], [[
        ;; query for structs
        (type_declaration (type_spec name: (type_identifier) @cap type: (struct_type))) 
    ]], [[
        ;; query for function calls
        (call_expression function: (selector_expression) @cap)
    ]]
                },

                search_patterns = {{"func", "<C-j>", true}, {"func", "<C-k>", false}},

                -- auto_jump = false,
                -- open_win_opts = { border = "double" },
                win_opts = {scrolloff = 1}

                -- disable_indentation = true
            })

            -- Lua
            nm.set({"zi", "zo", "zu"}, "*.lua", {
                events = {"BufEnter"},

                query = {
                    [[
         ((function_declaration) @cap)
         ((function_definition) @cap)
        ]], [[
        ((identifier) @cap (#eq? @cap "{cursorword}"))
        ]], [[
        ((for_statement) @cap)
        ((assignment_statement(expression_list((function_definition) @cap))))
        ((function_call (identifier)) @cap (#vim-match? @cap "^__*" ))
        ((function_call (dot_index_expression) @field (#eq? @field "vim.keymap.set")) @cap)
        ]]
                },

                regex = {{}, {[[^\s*---*\s\+\w\+]], [[--\s*=]]}, {[[^\s*---*\s\+\w\+]], [[--\s*=]]}, {}},

                search_patterns = {
                    {"function", "<C-j>", true}, {"function", "<C-k>", false}, {"keymap", "<A-j>", true},
                    {"keymap", "<A-k>", false}
                },

                -- auto_jump = false,
                -- open_win_opts = { border = "double" },
                win_opts = {scrolloff = 1}

                -- disable_indentation = true
            })

            -- Rust
            nm.set({"zi", "zo"}, "*.rs", {
                events = {"BufEnter"},

                query = {
                    [[
         ((function_item) @cap)
        ]], [[
        ((identifier) @cap (#eq? @cap "{cursorword}"))
        ]]
                },

                search_patterns = {{"fn", "<C-j>", true}, {"fn", "<C-k>", false}},

                -- auto_jump = false,
                -- open_win_opts = { border = "double" },
                win_opts = {scrolloff = 1}

                -- disable_indentation = true
            })
        end
    }, {"gpanders/editorconfig.nvim", event = "BufEnter"}, {
        "ray-x/go.nvim",
        ft = "go",
        dependencies = {"ray-x/guihua.lua"},
        opts = {dap_debug = true, dap_debug_gui = true},
        config = function(_, opts) require("go").setup(opts) end
    }, {
        "mfussenegger/nvim-dap",
        ft = {"go", "python", "c", "cpp"},

        dependencies = {
            {"theHamsta/nvim-dap-virtual-text"}, -- virtual text for debugger
            {
                "mfussenegger/nvim-dap-python", -- python debugger
                config = function() require("dap-python").setup("~/.virtualenvs/debugpy/bin/python") end
            }, {"leoluz/nvim-dap-go", config = function() require("dap-go").setup() end}, -- go debugger
            {
                "rcarriga/nvim-dap-ui", -- debugger UI
                config = function() require("dapui").setup() end
            }
        },
        init = function()
            vim.keymap.set("n", "<F4>", function() require("dapui").toggle() end,
                           {noremap = true, desc = "Toggle debugging"})
            vim.keymap.set("n", "<F5>", function() require("dap").toggle_breakpoint() end,
                           {noremap = true, desc = "Set breakpoint"})
            vim.keymap.set("n", "<F9>", function() require("dap").continue() end,
                           {noremap = true, desc = "Continue or start"})
            vim.keymap.set("n", "<F1>", function() require("dap").step_over() end, {noremap = true, desc = "Step over"})
            vim.keymap.set("n", "<F2>", function() require("dap").step_into() end, {noremap = true, desc = "Step into"})
            vim.keymap.set("n", "<F3>", function() require("dap").step_out() end, {noremap = true, desc = "Step out"})
        end,

        config = function()
            local dap = require("dap")
            local sign = vim.fn.sign_define

            sign("DapBreakpoint", {text = "●", texthl = "DapBreakpoint", linehl = "", numhl = ""})
            sign("DapBreakpointCondition", {text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = ""})
            sign("DapLogPoint", {text = "◆", texthl = "DapLogPoint", linehl = "", numhl = ""})

            -- https://github.com/microsoft/vscode-cpptools/releases/latest
            -- download cpptools-linux.vsix
            -- cd ~/software/cpptools-linux
            -- unzip ~/Downloads/cpptools-linux.vsix
            -- chmod +x extension/debugAdapters/bin/OpenDebugAD7
            dap.adapters.cppdbg = {
                type = "executable",
                id = "cppdbg",
                command = os.getenv("HOME") .. "/software/vscode-cpptools/extension/debugAdapters/bin/OpenDebugAD7"
            }

            dap.configurations.cpp = {
                {
                    name = "Launch file",
                    type = "cppdbg",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = true,
                    setupCommands = {
                        {
                            text = "-enable-pretty-printing",
                            description = "enable pretty printing",
                            ignoreFailures = false
                        }
                    }
                }, {
                    name = "Attach to gdbserver :1234",
                    type = "cppdbg",
                    request = "launch",
                    MIMode = "gdb",
                    miDebuggerServerAddress = "localhost:1234",
                    miDebuggerPath = "/usr/bin/gdb",
                    cwd = "${workspaceFolder}",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end
                }
            }

            dap.configurations.c = dap.configurations.cpp -- Reuse for c

            vim.fn.sign_define("DapBreakpoint", {text = "🛑", texthl = "", linehl = "", numhl = ""})
        end
    }, {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        opts = {
            signs = {
                add = {hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn"},
                change = {hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn"},
                delete = {hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn"},
                topdelete = {
                    hl = "GitSignsDelete",
                    text = "‾",
                    numhl = "GitSignsDeleteNr",
                    linehl = "GitSignsDeleteLn"
                },
                changedelete = {
                    hl = "GitSignsChange",
                    text = "~",
                    numhl = "GitSignsChangeNr",
                    linehl = "GitSignsChangeLn"
                }
            },
            on_attach = function(bufnr)
                local function map(mode, lhs, rhs, opts)
                    opts = vim.tbl_extend("force", {noremap = true, silent = true}, opts or {})
                    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
                end

                -- Navigation
                map("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr = true})
                map("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr = true})

                -- Actions
                -- map("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<CR>")
                -- map("v", "<leader>hs", "<cmd>Gitsigns stage_hunk<CR>")
                -- map("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>")
                -- map("v", "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>")
                -- map("n", "<leader>hS", "<cmd>Gitsigns stage_buffer<CR>")
                -- map("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>")
                -- map("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<CR>")
                -- map("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>")
                map("n", "<leader>hb", '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
                map("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<CR>")
                map("n", "<leader>hd", "<cmd>Gitsigns diffthis<CR>")
                map("n", "<leader>hD", '<cmd>lua require"gitsigns".diffthis("~")<CR>')
                -- map("n", "<leader>td", "<cmd>Gitsigns toggle_deleted<CR>")

                -- Text object
                map("o", "ih", ":<C-U>Gitsigns select_hunk<CR>")
                map("x", "ih", ":<C-U>Gitsigns select_hunk<CR>")
            end
        }
    }
}
