local nmok, nm = pcall(require, "neo-minimap")
if not nmok then
    vim.notify("Unable to require neo-minimap", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

nm.setup_defaults({height_toggle = {12, 36}, hl_group = "DiagnosticWarn"})

nm.source_on_save("~/.config/nvim/lua/plugins/neo-minimap.lua")

-- Markdown
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
        ((comment) @cap)
    ]], [[
        ;; query for structs /classes
        ((class_definition) @cap)
        ]]
    },

    -- auto_jump = false,
    -- open_win_opts = { border = "double" },
    win_opts = {scrolloff = 1},

    disable_indentation = true
})

-- C/CPP
nm.set({"zi", "zo", "zu"}, {"*.c", "*.h", "*.hpp", "*.cpp", "*.cc"}, {
    events = {"BufEnter"},

    query = {
        [[
        ;; query for functions/function declarations
        ((function_definition) @cap)
        (declaration declarator: (function_declarator)) @cap
    ]], [[
        ;; query for comments
        ((comment) @cap)
    ]], [[
        ;; query for structs /classes
        ((struct_specifier) @cap)
        ((class_specifier) @cap)
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

    query = {
        [[
        ;; query
        ((method_declaration) @cap)
        ((function_declaration) @cap)
        (call_expression function: (func_literal) @cap)
    ]], [[
        ;; query for comments
        ((comment) @cap)
    ]], [[
        ;; query for structs
        (type_declaration (type_spec name: (type_identifier) @cap type: (struct_type))) 
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
    ;; query
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))
    ]], 1, [[
    ;; query
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))
    ((field (identifier) @cap) (#eq? @cap "keymaps"))
    ]], [[
    ;; query
    ((for_statement) @cap)
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))
    ((function_call (identifier)) @cap (#vim-match? @cap "^__*" ))
    ((function_call (dot_index_expression) @field (#eq? @field "vim.keymap.set")) @cap)
    ]], [[
    ;; query
    ((for_statement) @cap)
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))
    ]]
    },

    regex = {
        {}, {[[^\s*---*\s\+\w\+]], [[--\s*=]]},
        {[[^\s*---*\s\+\w\+]], [[--\s*=]]}, {}
    },

    search_patterns = {
        {"function", "<C-j>", true}, {"function", "<C-k>", false},
        {"keymap", "<A-j>", true}, {"keymap", "<A-k>", false}
    },

    -- auto_jump = false,
    -- open_win_opts = { border = "double" },
    win_opts = {scrolloff = 1}

    -- disable_indentation = true
})
