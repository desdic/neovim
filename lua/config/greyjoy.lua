local ok, greyjoy = pcall(require, "greyjoy")
if not ok then
    vim.notify("Unable to require greyjoy", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

greyjoy.setup({
    output_results = "toggleterm",
	last_first= true,
    extensions = {
        generic = {
            commands = {
                ["run test.py"] = {
                    command = {"./test.py"},
                    filetype = "python",
                    filename = "test.py"
                },
				["run main.go"] = {
					command = {"go", "run", "main.go"},
                    filetype = "go",
                    filename = "main.go"
				}
            }
        },
		kitchen = {
			targets = {"converge", "verify", "destroy", "test"},
			include_all = false,
		}
    }
})
greyjoy.load_extension("generic")
-- greyjoy.load_extension("vscode_tasks")
greyjoy.load_extension("makefile")
greyjoy.load_extension("kitchen")

vim.keymap.set("n", "<Leader>r", ":Greyjoy<CR>", {noremap = true, silent = true, desc = "List methods"})
