return {
    "mfussenegger/nvim-lint",
    event = {
        "BufReadPre",
        "BufNewFile",
    },
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            python = { "ruff", "pylint", "mypy" },
            c = { "flawfinder", "clangtidy" },
            go = { "golangcilint" },
            -- lua    = { "luacheck" }, -- TODO luacheck can't find vim and other globals
            -- make   = { "checkmake" },
            sh = { "shellcheck" },
            ruby = { "rubocop" },
            json = { "jq" },
        }
        lint.linters.golangcilint.args = {
            "run",
            "--enable-all",
            "--disable", "lll",
            "--disable", "depguard",
            "--out-format",
            "json",
            function()
                return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
            end,
        }

        lint.linters.rubocop.args = {
            "--format",
            "json",
            "--force-exclusion",
            "--config",
            "~/.rubocop.yml",
        }

        -- TODO
        -- lint.linters.checkmake = {
        --     cmd = "checkmake",
        --     stdin = false,
        --     append_fname = true,
        --     args = {},
        -- }

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })

        vim.keymap.set("n", "<leader>l", function()
            lint.try_lint()
        end, { desc = "Trigger linting for current file" })
    end,
}
