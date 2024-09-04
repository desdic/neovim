return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        dependencies = {
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
                    "http",
                    "json",
                    "json5",
                    "jsonc",
                    "lua",
                    "make",
                    "markdown",
                    "markdown_inline",
                    "meson",
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
                    "zig",
                },
                indent = { enable = true, disable = {} },
                highlight = {
                    enable = true, -- false will disable the whole extension
                    disable = function(lang, bufnr)
                        return lang == "yaml" and vim.api.nvim_buf_line_count(bufnr) > 5000
                    end,
                    additional_vim_regex_highlighting = false,
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
                    -- swap = {
                    --     enable = true,
                    --     swap_next = { ["<leader>fa"] = "@parameter.inner" },
                    --     swap_previous = { ["<leader>fA"] = "@parameter.inner" },
                    -- },
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
            })
        end,
    },
}
