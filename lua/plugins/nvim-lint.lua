return {
    "mfussenegger/nvim-lint",
    event = {
        "BufReadPre",
        "BufNewFile",
    },
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            c = { "flawfinder" },
            cmake = { "cmakelint" },
            go = { "golangcilint" },
            json = { "jq" },
            python = { "ruff", "pylint" },
            sh = { "shellcheck" },
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
