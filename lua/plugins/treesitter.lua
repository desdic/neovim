local M = {
    "nvim-treesitter/nvim-treesitter",
    build = function()
        require("nvim-treesitter.install").update({with_sync = true})
    end,
    dependencies = {
        {"nvim-treesitter/nvim-treesitter-refactor"},
        {"nvim-treesitter/nvim-treesitter-textobjects"},
        {"nvim-treesitter/nvim-treesitter-context"},
        {"JoosepAlviste/nvim-ts-context-commentstring"},
        {"nvim-treesitter/playground"}, {"p00f/nvim-ts-rainbow"}
    },
    event = "VeryLazy"
}

function M.config()
    require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "bash", "c", "cpp", "dockerfile", "go", "json", "lua", "python",
            "ruby", "yaml", "toml", "markdown", "markdown_inline", "glsl",
            "rust"
        },
        ignore_install = {"javascript", "haskell"}, -- List of parsers to ignore installing
        indent = {enable = true, disable = {}},
        highlight = {
            enable = true -- false will disable the whole extension
            -- disable = {"rust"} -- list of language that will be disabled
        },
        rainbow = {
            enable = true,
            extended = true,
            max_file_lines = 5000 -- Do not enable for files with more than 5000 lines, int
        },
        refactor = {
            smart_rename = {enable = true, keymaps = {smart_rename = "grr"}}
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<CR>",
                scope_incremental = "<CR>",
                node_incremental = "<TAB>",
                node_decremental = "<S-TAB>"
            }
        },
        textobjects = {
            select = {
                enable = true,

                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,

                keymaps = {
                    -- ["ff"] = "@function.outer",
                    -- ["fb"] = "@block.inner",
                    -- ["fc"] = "@class.outer",
                    -- ["fl"] = "@loop.outer",
                    -- ["if"] = "@function.inner",
                    -- ["ic"] = "@class.inner",
                    -- ["il"] = "@loop.inner",
                    -- ["fi"] = "@conditional.inner"

                    ["aa"] = "@parameter.outer",
                    ["ia"] = "@parameter.inner",
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner"
                }
            },
            swap = {
                enable = true,
                swap_next = {["fa"] = "@parameter.inner"},
                swap_previous = {["fA"] = "@parameter.inner"}
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
                    ["]o"] = "@call.outer"
                },
                goto_previous_start = {
                    ["[f"] = "@function.outer",
                    ["[b"] = "@block.inner",
                    ["[c"] = "@class.outer",
                    ["[l"] = "@loop.outer",
                    ["[i"] = "@conditional.outer",
                    ["[p"] = "@parameter.inner",
                    ["[o"] = "@call.outer"
                }
                -- goto_next_end = {
                -- 	["fF"] = "@function.outer",
                -- 	["fB"] = "@block.inner",
                -- 	["fC"] = "@class.outer",
                -- 	["fL"] = "@loop.outer",
                -- 	["fP"] = "@parameter.inner",
                -- },
            }
        },
        playground = {
            enable = true,
            disable = {},
            updatetime = 5, -- Debounced time for highlighting nodes in the playground from source code
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
                show_help = "?"
            }
        },
        context_commentstring = {enable = true}
    })

    local ok, tsc = pcall(require, "treesitter-context")
    if not ok then
        vim.notify("Unable to require treesitter-context",
                   vim.lsp.log_levels.ERROR, {title = "Plugin error"})
        return
    end

    tsc.setup({
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
            -- For all filetypes
            -- Note that setting an entry here replaces all other patterns for this entry.
            -- By setting the 'default' entry below, you can control which nodes you want to
            -- appear in the context window.
            default = {
                "class", "function", "method", "for", "while", "if", "switch",
                "case"
            },
            -- Patterns for specific filetypes
            -- If a pattern is missing, *open a PR* so everyone can benefit.
            markdown = {"section"},
            json = {"pair"},
            yaml = {"block_mapping_pair"}
        },
        exact_patterns = {
            -- Example for a specific filetype with Lua patterns
            -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
            -- exactly match "impl_item" only)
            -- rust = true,
        },

        -- [!] The options below are exposed but shouldn't require your attention,
        --     you can safely ignore them.

        zindex = 20, -- The Z-index of the context window
        mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil
    })
end

return M
