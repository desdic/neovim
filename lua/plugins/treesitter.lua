return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        lazy = false,
        build = ":TSUpdate",
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        branch = "main",
        config = function()
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

            local ts = require("nvim-treesitter")
            ts.install(parsers):wait(300000)

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
                desc = "Enable treesitter highlighting and indentation",
                callback = function(event)
                    local lang = vim.treesitter.language.get_lang(event.match) or event.match
                    -- local buf = event.buf

                    if vim.treesitter.query.get(lang, "highlights") then
                        vim.treesitter.start()
                    end
                    if vim.treesitter.query.get(lang, "indents") then
                        vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
                    end
                end,
            })
        end,
    },
}
