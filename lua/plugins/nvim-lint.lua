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
            c = { "flawfinder" },
            go = { "golangcilint" },
            sh = { "shellcheck" },
            ruby = { "rubocop" },
            json = { "jq" },
        }

        lint.linters.golangcilint.args = {
            "run",
            "--enable-all",
            "--disable",
            "lll",
            "--disable",
            "depguard",
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

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })

        vim.keymap.set("n", "<leader>lf", function()
            lint.try_lint()
        end, { desc = "Trigger linting for current file" })
    end,
}
