return {
    {
        "L3MON4D3/LuaSnip",                 -- snippet completions
        dependencies = {
            "rafamadriz/friendly-snippets", -- collection of snippets
        },
        build = "make install_jsregexp",
        config = function()
            local ls = require("luasnip")

            require("luasnip.loaders.from_vscode").lazy_load()

            local lsloader = require("luasnip.loaders.from_lua")

            lsloader.load({ paths = "~/.config/nvim/snippets" })

            local types = require("luasnip.util.types")

            ls.config.set_config({
                -- Keep last snippet to jump around
                history = true,

                -- Enable dynamic snippets
                updateevents = "TextChanged,TextChangedI",
                -- For cleaning up snippets whose text was deleted
                delete_check_events = "TextChanged",

                enable_autosnippets = true,

                ext_opts = {
                    -- [types.insertNode] = {active = {virt_text = {{"●", "DiffAdd"}}}},
                    [types.choiceNode] = { active = { virt_text = { { "●", "Operator" } } } },
                },
            })

            -- Extend changelog with debchangelog
            ls.filetype_extend("changelog", { "debchangelog" })

            vim.keymap.set({ "i", "s" }, "<c-j>", function()
                if ls.expand_or_jumpable() then
                    ls.expand_or_jump()
                end
            end, { silent = true })

            vim.keymap.set({ "i", "s" }, "<c-k>", function()
                if ls.jumpable(-1) then
                    ls.jump(-1)
                end
            end, { silent = true })

            vim.keymap.set("i", "<c-l>", function()
                if ls.choice_active() then
                    ls.change_choice(1)
                end
            end)
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "onsails/lspkind-nvim",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
            "lukas-reineke/cmp-under-comparator",
            {
                'windwp/nvim-autopairs',
                opts = {
                    check_ts = true,
                    disable_filetype = { "TelescopePrompt", "vim" },
                    fast_wrap = {},
                }
            },
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
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                formatting = { format = lspkind.cmp_format({ maxwidth = 50, ellipsis_char = "..." }) },
                sorting = {
                    priority_weight = 1.0,
                    comparators = {
                        compare.offset,
                        compare.exact,
                        compare.score,
                        compare.recently_used,
                        require("cmp-under-comparator").under,
                        compare.kind,
                    },
                },
                min_length = 0, -- allow for `from package import _` in Python
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }), -- no not select first item
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "luasnip" },
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "nvim_lua" },
                    { name = "path" },
                    { name = "nvim_lsp_signature_help" },
                },
                performance = {
                    max_view_entries = 50,
                },
                window = { documentation = cmp.config.window.bordered(), completion = cmp.config.window.bordered() },
            })

            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )
        end,

    },
    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        opts = {
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring.internal").calculate_commentstring()
                        or vim.bo.commentstring
                end,
            },
        },
        config = function(_, opts)
            require("mini.comment").setup(opts)
        end,
    },
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500,
                custom_textobjects = {
                    -- cao change outer block/conditional/loop
                    o = ai.gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }, {}),
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                    -- caa = change function argument
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
                },
            }
        end,
        config = function(_, opts)
            require("mini.ai").setup(opts)
            -- cif = change inner function
        end,
    },
    {
        "desdic/greyjoy.nvim",
        keys = {
            { "<Leader>gr", "<cmd>Greyjoy<CR>",      desc = "[G]reyjoy [r]un" },
            { "<Leader>gf", "<cmd>Greyjoy fast<CR>", desc = "[G]reyjoy run [f]ast" },
        },
        config = function()
            local greyjoy = require("greyjoy")
            greyjoy.setup({
                output_results = "toggleterm",
                last_first = true,
                extensions = {
                    generic = {
                        commands = {
                            ["run {filename}"] = { command = { "python3", "{filename}" }, filetype = "python" },
                            ["run main.go"] = {
                                command = { "go", "run", "main.go" },
                                filetype = "go",
                                filename = "main.go",
                            },
                            ["build main.go"] = {
                                command = { "go", "build", "main.go" },
                                filetype = "go",
                                filename = "main.go",
                            },
                        },
                    },
                    kitchen = { targets = { "converge", "verify", "destroy", "test" }, include_all = false },
                },
                run_groups = { fast = { "generic", "makefile", "cargo" } },
            })

            greyjoy.load_extension("kitchen")
            greyjoy.load_extension("generic")
            greyjoy.load_extension("makefile")
            greyjoy.load_extension("cargo")
        end,
    },
    {
        "ray-x/go.nvim",
        ft = { "go", "gomod" },
        dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter" },
        build = ':lua require("go.install").update_all_sync()',
        opts = { dap_debug = true, dap_debug_gui = true, lsp_inlay_hints = { enable = false } },
        config = function(_, opts)
            require("go").setup(opts)
        end,
    },
    {
        "mfussenegger/nvim-dap",
        keys = {
            {
                "<F4>",
                function()
                    require("dapui").toggle()
                end,
                desc = "Start DAP UI",
            },
            {
                "<F5>",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "DAP Set breakpoint",
            },
            {
                "<F9>",
                function()
                    require("dap").continue()
                end,
                desc = "Start/Continue",
            },
            {
                "<F1>",
                function()
                    require("dap").step_over()
                end,
                desc = "DAP Step over",
            },
            {
                "<F2>",
                function()
                    require("dap").step_into()
                end,
                desc = "DAP Step into",
            },
            {
                "<F3>",
                function()
                    require("dap").step_out()
                end,
                desc = "DAP Step out",
            },
        },
        dependencies = {
            { "theHamsta/nvim-dap-virtual-text" }, -- virtual text for debugger
            {
                "mfussenegger/nvim-dap-python",    -- python debugger
                config = function()
                    require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
                end,
            },
            {
                "leoluz/nvim-dap-go",
                config = function()
                    require("dap-go").setup()
                end,
            },                          -- go debugger
            {
                "rcarriga/nvim-dap-ui", -- debugger UI
                config = function()
                    require("dapui").setup()
                end,
            },
        },
        config = function()
            local dap = require("dap")
            local sign = vim.fn.sign_define

            sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
            sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
            sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })

            -- https://github.com/microsoft/vscode-cpptools/releases/latest
            -- download cpptools-linux.vsix
            -- cd ~/software/cpptools-linux
            -- unzip ~/Downloads/cpptools-linux.vsix
            -- chmod +x extension/debugAdapters/bin/OpenDebugAD7
            dap.adapters.cppdbg = {
                type = "executable",
                id = "cppdbg",
                command = os.getenv("HOME") .. "/software/vscode-cpptools/extension/debugAdapters/bin/OpenDebugAD7",
            }

            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = "/usr/bin/codelldb",
                    args = { "--port", "${port}", "--settings", '{"showDisassembly" : "never"}' },
                },
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
                            ignoreFailures = false,
                        },
                    },
                },
                {
                    name = "Attach to gdbserver :1234",
                    type = "cppdbg",
                    request = "launch",
                    MIMode = "gdb",
                    miDebuggerServerAddress = "localhost:1234",
                    miDebuggerPath = "/usr/bin/gdb",
                    cwd = "${workspaceFolder}",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                },
            }

            dap.configurations.c = dap.configurations.cpp -- Reuse for c

            dap.configurations.rust = {
                {
                    name = "Rust debug",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = true,
                },
            }
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        opts = {
            signs = {
                add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
                change = {
                    hl = "GitSignsChange",
                    text = "│",
                    numhl = "GitSignsChangeNr",
                    linehl = "GitSignsChangeLn",
                },
                delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
                topdelete = {
                    hl = "GitSignsDelete",
                    text = "‾",
                    numhl = "GitSignsDeleteNr",
                    linehl = "GitSignsDeleteLn",
                },
                changedelete = {
                    hl = "GitSignsChange",
                    text = "~",
                    numhl = "GitSignsChangeNr",
                    linehl = "GitSignsChangeLn",
                },
            },
            on_attach = function(bufnr)
                local function map(mode, lhs, rhs, opts)
                    opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
                    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
                end

                -- Navigation
                map("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
                map("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

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
            end,
        },
    },
    {
        "folke/trouble.nvim",
        event = "VeryLazy",
        dependencies = { { "nvim-tree/nvim-web-devicons" } },
        keys = {
            { "<Leader>xx", "<cmd>TroubleToggle<CR>",          desc = "Toggle trouble" },
            { "<Leader>xq", "<cmd>TroubleToggle quickfix<CR>", desc = "Trouble quickfix" },
        },
        opts = {},
        config = function(_, opts)
            require("trouble").setup(opts)
        end,
    },
    {
        "NeogitOrg/neogit",
        dependencies = "nvim-lua/plenary.nvim",
        config = true,
        cmd = "Neogit",
        keys = {
            {
                "<Leader>g",
                function()
                    local neogit = require("neogit")
                    neogit.open({ kind = "vsplit" })
                end,
                desc = "Neogit"
            }
        }
    }
}
