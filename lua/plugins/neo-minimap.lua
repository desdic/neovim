local M = { "ziontee113/neo-minimap", ft = { "go", "lua", "python", "cpp", "c", "markdown", "yaml", "rust" } }

function M.config()
    local nm = require("neo-minimap")

    nm.setup_defaults({ height_toggle = { 12, 36 }, hl_group = "DiagnosticWarn" })

    nm.source_on_save("~/.config/nvim/lua/plugins/neo-minimap.lua")

    -- Yaml
    nm.set({ "zi", "zo", "zu" }, { "docker-compose*.yml" }, {
        events = { "BufEnter" },

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
    ]]       , [[
        ;; query for functions/function declarations
        ((comment) @cap)
    ]]       , 1
        },

        -- auto_jump = false,
        -- open_win_opts = { border = "double" },
        win_opts = { scrolloff = 1 },

        disable_indentation = true
    })

    -- Markdown
    nm.set({ "zi", "zo", "zu" }, { "*.md" }, {
        events = { "BufEnter" },

        query = {
            [[
        ;; query for functions/function declarations
        ((atx_heading) @cap)
    ]]       , [[
        ;; query for functions/function declarations
        ((fenced_code_block) @cap)
    ]]       , 1
        },

        -- auto_jump = false,
        -- open_win_opts = { border = "double" },
        win_opts = { scrolloff = 1 },

        disable_indentation = true
    })

    -- Python
    nm.set({ "zi", "zo", "zu" }, { "*.py" }, {
        events = { "BufEnter" },

        query = {
            [[
        ;; query for functions/function declarations
        ((function_definition) @cap)
    ]]       , [[
        ;; query for comments
        ((identifier) @cap (#eq? @cap "{cursorword}"))
    ]]       , [[
        ;; query for structs /classes
        ((class_definition) @cap)
        ]]   , [[
        ;; query for function calls
        (call function: (identifier) @cap)
        ]]
        },

        -- auto_jump = false,
        -- open_win_opts = { border = "double" },
        win_opts = { scrolloff = 1 },

        disable_indentation = true
    })

    -- C/CPP
    nm.set({ "zi", "zo", "zu" }, { "*.c", "*.h", "*.hpp", "*.cpp", "*.cc", "*.frag", "*.vert" }, {
        events = { "BufEnter" },

        query = {
            [[
        ;; query for functions/function declarations
        ((function_definition) @cap)
        (declaration declarator: (function_declarator)) @cap
    ]]       , [[
        ((identifier) @cap (#eq? @cap "{cursorword}"))
    ]]       , [[
        ;; query for structs /classes
        ((struct_specifier) @cap)
        ((class_specifier) @cap)
        ]]   , [[
        ;; query for function calls
        (call_expression function: (identifier) @cap)
        ]]
        },

        search_patterns = {
            { "void", "<C-j>", true }, { "void", "<C-k>", false }
            -- {"keymap", "<A-j>", true}, {"keymap", "<A-k>", false}
        },

        -- auto_jump = false,
        -- open_win_opts = { border = "double" },
        win_opts = { scrolloff = 1 },

        disable_indentation = true
    })

    -- Go
    nm.set({ "zi", "zo", "zu" }, "*.go", {
        events = { "BufEnter" },
        -- ((function_call (dot_index_expression) @field (#eq? @field "vim.keymap.set")) @cap)
        query = {
            [[
        ;; query
        ((method_declaration) @cap)
        ((function_declaration) @cap)
        (call_expression function: (func_literal) @cap)
        ;;(method_declaration name: (field_identifier) @name (#eq? @name "{cursorword}")) @cap
    ]]       , [[
        ((identifier) @cap (#eq? @cap "{cursorword}"))
    ]]       , [[
        ;; query for structs
        (type_declaration (type_spec name: (type_identifier) @cap type: (struct_type))) 
    ]]       , [[
        ;; query for function calls
        (call_expression function: (selector_expression) @cap)
    ]]
        },

        search_patterns = { { "func", "<C-j>", true }, { "func", "<C-k>", false } },

        -- auto_jump = false,
        -- open_win_opts = { border = "double" },
        win_opts = { scrolloff = 1 }

        -- disable_indentation = true
    })

    -- Lua
    nm.set({ "zi", "zo", "zu" }, "*.lua", {
        events = { "BufEnter" },

        query = {
            [[
         ((function_declaration) @cap)
         ((function_definition) @cap)
        ]]   , [[
        ((identifier) @cap (#eq? @cap "{cursorword}"))
        ]]   , [[
        ((for_statement) @cap)
        ((assignment_statement(expression_list((function_definition) @cap))))
        ((function_call (identifier)) @cap (#vim-match? @cap "^__*" ))
        ((function_call (dot_index_expression) @field (#eq? @field "vim.keymap.set")) @cap)
        ]]
        },

        regex = { {}, { [[^\s*---*\s\+\w\+]], [[--\s*=]] }, { [[^\s*---*\s\+\w\+]], [[--\s*=]] }, {} },

        search_patterns = {
            { "function", "<C-j>", true }, { "function", "<C-k>", false }, { "keymap", "<A-j>", true },
            { "keymap", "<A-k>", false }
        },

        -- auto_jump = false,
        -- open_win_opts = { border = "double" },
        win_opts = { scrolloff = 1 }

        -- disable_indentation = true
    })

    -- Rust
    nm.set({ "zi", "zo" }, "*.rs", {
        events = { "BufEnter" },

        query = {
            [[
         ((function_item) @cap)
        ]]   , [[
        ((identifier) @cap (#eq? @cap "{cursorword}"))
        ]]
        },

        search_patterns = { { "fn", "<C-j>", true }, { "fn", "<C-k>", false } },

        -- auto_jump = false,
        -- open_win_opts = { border = "double" },
        win_opts = { scrolloff = 1 }

        -- disable_indentation = true
    })
end

return M
