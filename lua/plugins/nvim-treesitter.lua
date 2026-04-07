vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
}, { confirm = false })

local parsers = {
    "bash",
    "c",
    "comment",
    "cpp",
    "dockerfile",
    "glsl",
    "go",
    "gomod",
    "gosum",
    "gotmpl",
    "gowork",
    "http",
    "json",
    "json5",
    "kdl",
    -- "kulala_http",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "mermaid",
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
}

vim.defer_fn(function()
    local ts = require("nvim-treesitter")
    ts.install(parsers):wait(300000)

    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end, 10)
