-- import null-ls plugin safely
local setup, null_ls = pcall(require, "null-ls")
if not setup then return end

local helpok, h = pcall(require, "null-ls.helpers")
if not helpok then
    vim.notify("Unable to require null-ls.helpers", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

-- for conciseness
local formatting = null_ls.builtins.formatting -- to setup formatters
local diagnostics = null_ls.builtins.diagnostics -- to setup linters

local gci_format = {
    method = null_ls.methods.FORMATTING,
    filetypes = {"go"},
    generator = h.formatter_factory({
        command = "gci",
        args = {"-w", "$FILENAME"},
        to_temp_file = true
    })
}

-- configure null_ls
null_ls.setup({
    -- setup formatters & linters
    sources = {
        formatting.stylua, formatting.lua_format, formatting.black,
        formatting.gofmt, formatting.gofumpt, formatting.goimports,
        diagnostics.golangci_lint.with({
            args = {
                "run", "--enable-all", "--disable", "lll", "--disable", "godot",
                "--out-format=json", "$DIRNAME", "--path-prefix", "$ROOT"
            }
        }), null_ls.builtins.formatting.rubocop.with({
            args = {
                "--auto-correct", "-f", "-c", HOME_PATH .. "/.work-rubocop.yml",
                "quiet", "--stderr", "--stdin", "$FILENAME"
            }
        }), null_ls.builtins.diagnostics.rubocop.with({
            args = {
                "-c", HOME_PATH .. "/.work-rubocop.yml", "-f", "json",
                "--stdin", "$FILENAME"
            }
        }), gci_format
    }
})
