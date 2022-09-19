local ok, greyjoy = pcall(require, "greyjoy")
if not ok then
    vim.notify("Unable to require greyjoy", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

greyjoy.setup({
    output_results = "toggleterm",
    extensions = {
        generic = {
            commands = {
                ["run test.py"] = {
                    command = {"./test.py"},
                    filetype = "python",
                    filename = "test.py"
                }
            }
        },
		kitchen = {
			targets = {"converge", "verify", "destroy"},
			include_all = false,
		}
    }
})
greyjoy.load_extension("generic")
-- greyjoy.load_extension("vscode_tasks")
greyjoy.load_extension("makefile")
greyjoy.load_extension("kitchen")

vim.keymap.set("n", "<Leader>r", ":Greyjoy<CR>", {noremap = true, silent = true, desc = "List methods"})
