local ok, greyjoy = pcall(require, "greyjoy")
if not ok then
    vim.notify("Unable to require greyjoy", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

greyjoy.setup({
    output_results = "toggleterm",
    last_first = true,
    extensions = {
        generic = {
            commands = {
                ["run {filename}"] = {
                    command = {"python3", "{filename}"},
                    filetype = "python"
                },
                ["run main.go"] = {
                    command = {"go", "run", "main.go"},
                    filetype = "go",
                    filename = "main.go"
                },
                ["build main.go"] = {
                    command = {"go", "build", "main.go"},
                    filetype = "go",
                    filename = "main.go"
                }
            }
        },
        kitchen = {
            targets = {"converge", "verify", "destroy", "test"},
            include_all = false
        }
    },
    run_groups = {fast = {"generic", "makefile", "cargo"}}
})

greyjoy.load_extension("kitchen")
greyjoy.load_extension("generic")
-- greyjoy.load_extension("vscode_tasks")
greyjoy.load_extension("makefile")
greyjoy.load_extension("cargo")

vim.keymap.set("n", "<Leader>gr", ":Greyjoy<CR>",
               {noremap = true, silent = true, desc = "Run greyjoy"})

vim.keymap.set("n", "<Leader>gf", ":Greyjoy fast<CR>",
               {noremap = true, silent = true, desc = "Run greyjoy"})
