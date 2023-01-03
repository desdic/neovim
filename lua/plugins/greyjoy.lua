local M = {
    "desdic/greyjoy.nvim",
    lazy = false,
    keys = {
        {"<Leader>gr", ":Greyjoy<CR>", desc = "[G]reyjoy [r]un"},
        {"<Leader>gf", ":Greyjoy fast<CR>", desc = "[G]reyjoy run [f]ast"}
    }
}

function M.config()
    local greyjoy = require("greyjoy")
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
end

return M
