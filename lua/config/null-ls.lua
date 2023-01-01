local M = {
    "jose-elias-alvarez/null-ls.nvim",
    build = {
        "go install github.com/daixiang0/gci@latest",
        "go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest",
        "go install golang.org/x/tools/cmd/goimports@latest"
    },
    event = "BufReadPre"
}

function M.config()
    local null_ls = require("null-ls")
    local h = require("null-ls.helpers")

    -- for conciseness
    local formatting = null_ls.builtins.formatting -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters

    local gci_format = {
        method = null_ls.methods.FORMATTING,
        filetypes = { "go" },
        generator = h.formatter_factory({ command = "gci", args = { "-w", "$FILENAME" }, to_temp_file = true })
    }

    -- configure null_ls
    null_ls.setup({
        -- setup formatters & linters
        sources = {
            formatting.stylua, formatting.lua_format, formatting.black, formatting.rustfmt, formatting.gofmt,
            formatting.gofumpt, formatting.clang_format, formatting.goimports, diagnostics.golangci_lint.with({
                args = {
                    "run", "--enable-all", "--disable", "lll", "--disable", "godot", "--out-format=json", "$DIRNAME",
                    "--path-prefix", "$ROOT"
                }
            }), gci_format, null_ls.builtins.formatting.rubocop.with({
                args = {
                    "--auto-correct", "-f", "-c", HOME_PATH .. "/.work-rubocop.yml", "quiet", "--stderr", "--stdin",
                    "$FILENAME"
                }
            }), null_ls.builtins.diagnostics.rubocop.with({
                args = { "-c", HOME_PATH .. "/.work-rubocop.yml", "-f", "json", "--stdin", "$FILENAME" }
            })
        }
    })
end

return M
