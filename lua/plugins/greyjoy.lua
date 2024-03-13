return {
    "desdic/greyjoy.nvim",
    keys = {
        { "<Leader>gr", "<cmd>Greyjoy<CR>", desc = "[G]reyjoy [r]un" },
        { "<Leader>gf", "<cmd>Greyjoy fast<CR>", desc = "[G]reyjoy run [f]ast" },
    },
    dependencies = {
        { "akinsho/toggleterm.nvim" },
    },
    cmd = "Greyjoy",
    config = function()
        local greyjoy = require("greyjoy")
        greyjoy.setup({
            output_results = "toggleterm",
            last_first = true,
            extensions = {
                generic = {
                    commands = {
                        ["run {filename}"] = { command = { "python3", "{filename}" }, filetype = "python" },
                        ["run main.go"] = {
                            command = { "go", "run", "main.go" },
                            filetype = "go",
                            filename = "main.go",
                        },
                        ["build main.go"] = {
                            command = { "go", "build", "main.go" },
                            filetype = "go",
                            filename = "main.go",
                        },
                    },
                },
                kitchen = { group_id = 2, targets = { "converge", "verify", "destroy", "test" }, include_all = false },
                docker_compose = { group_id = 3 },
                cargo = { group_id = 4 },
            },
            run_groups = { fast = { "generic", "makefile", "cargo", "docker_compose" } },
        })

        greyjoy.load_extension("kitchen")
        greyjoy.load_extension("generic")
        greyjoy.load_extension("makefile")
        greyjoy.load_extension("cargo")
        greyjoy.load_extension("docker_compose")
    end,
}
