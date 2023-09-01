return {
    {
        "nvim-treesitter/playground",
        cmd = "TSPlaygroundToggle",
        keys = {
            { "<Leader>tp", "<cmd>TSPlaygroundToggle<CR>" },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "BufReadPre",
        opts = {
            enable = true,         -- Enable this plugin (Can be enabled/disabled later via commands)
            max_lines = 0,         -- How many lines the window should span. Values <= 0 mean no limit.
            trim_scope = "outer",  -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
            min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
            patterns = {           -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
                default = {
                    "class",
                    "function",
                    "method",
                    "for",
                    "while",
                    "if",
                    "switch",
                    "case",
                },
                markdown = { "section" },
                json = { "pair" },
                yaml = { "block_mapping_pair" },
            },
            zindex = 20,     -- The Z-index of the context window
            mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
            separator = nil,
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-refactor" },
            { "nvim-treesitter/nvim-treesitter-textobjects" },
            { "JoosepAlviste/nvim-ts-context-commentstring" },
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "cpp",
                    "dockerfile",
                    "glsl",
                    "go",
                    "gomod",
                    "json",
                    "json5",
                    "jsonc",
                    "lua",
                    "make",
                    "markdown",
                    "markdown_inline",
                    "perl",
                    "php",
                    "python",
                    "query",
                    "regex",
                    "ruby",
                    "rust",
                    "sql",
                    "toml",
                    "vim",
                    "vimdoc",
                    "yaml",
                },
                indent = { enable = true, disable = {} },
                highlight = {
                    enable = true, -- false will disable the whole extension
                    -- disable = {"rust"} -- list of language that will be disabled
                    disable = function(lang, bufnr)
                        return lang == "yaml" and vim.api.nvim_buf_line_count(bufnr) > 5000
                    end,
                },
                refactor = {
                    smart_rename = {
                        enable = true,
                        keymaps = { smart_rename = "grr" },
                    },
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = false,
                        node_decremental = "<BS>",
                    },
                },
                textobjects = {
                    select = {
                        enable = true,

                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,

                        keymaps = {
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = { ["fa"] = "@parameter.inner" },
                        swap_previous = { ["fA"] = "@parameter.inner" },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]b"] = "@block.inner",
                            ["]c"] = "@class.outer",
                            ["]l"] = "@loop.outer",
                            ["]i"] = "@conditional.outer",
                            ["]p"] = "@parameter.inner",
                            ["]o"] = "@call.outer",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[b"] = "@block.inner",
                            ["[c"] = "@class.outer",
                            ["[l"] = "@loop.outer",
                            ["[i"] = "@conditional.outer",
                            ["[p"] = "@parameter.inner",
                            ["[o"] = "@call.outer",
                        },
                    },
                },
                query_linter = {
                    enable = true,
                    use_virtual_text = true,
                    lint_events = { "BufWrite", "CursorHold" },
                },
                playground = {
                    enable = true,
                    disable = {},
                    updatetime = 5,          -- Debounced time for highlighting nodes in the playground from source code
                    persist_queries = false, -- Whether the query persists across vim sessions
                    keybindings = {
                        toggle_query_editor = "o",
                        toggle_hl_groups = "i",
                        toggle_injected_languages = "t",
                        toggle_anonymous_nodes = "a",
                        toggle_language_display = "I",
                        focus_language = "f",
                        unfocus_language = "F",
                        update = "R",
                        goto_node = "<cr>",
                        show_help = "?",
                    },
                },
                context_commentstring = {
                    enable = true,
                    enable_autocmd = false,
                },
            })
        end,
    },
}
