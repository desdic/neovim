vim.pack.add({
    { src = "https://github.com/mfussenegger/nvim-lint", load = false },
}, { confirm = false })

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "go", "gomod", "gosum", "c", "cpp", "json", "python", "cmake" },
    callback = function(event)
        if vim.g.lint_nvim_loaded then
            return
        end

        vim.cmd("packadd nvim-lint")

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

        vim.g.lint_nvim_loaded = true
    end,
})
