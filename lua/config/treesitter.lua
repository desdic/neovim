local ok, ntconfig = pcall(require, "nvim-treesitter.configs")
if not ok then
    vim.notify("Unable to require nvim-treesitter.configs",
               vim.lsp.log_levels.ERROR, {title = "Plugin error"})
    return
end

ntconfig.setup({
    -- ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = {
        "bash", "c", "cpp", "dockerfile", "go", "json", "lua", "python", "ruby",
        "yaml", "toml"
    },
    ignore_install = {"javascript", "haskell"}, -- List of parsers to ignore installing
    indent = {enable = true, disable = {"python"}},
    highlight = {
        enable = true, -- false will disable the whole extension
        disable = {"rust"} -- list of language that will be disabled
    },
    rainbow = {
        enable = true,
        max_file_lines = 1000 -- Do not enable for files with more than 1000 lines, int
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm"
        }
    },
    refactor = {
        navigation = {
            enable = true,
            keymaps = {
                goto_definition = "gnd",
                list_definitions = "gnD",
                list_definitions_toc = "gO",
                goto_next_usage = "<a-*>",
                goto_previous_usage = "<a-#>"
            }
        }
    },
    textobjects = {
        select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                ["iC"] = "@conditional.inner",
                ["aC"] = "@conditional.outer",
                ["ib"] = "@block.inner",
                ["ab"] = "@block.outer"
            }
        },
        swap = {
            enable = true,
            swap_next = {["<leader>a"] = "@parameter.inner"},
            swap_previous = {["<leader>A"] = "@parameter.inner"}
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer"
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer"
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer"
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer"
            }
        }
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
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
