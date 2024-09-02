return {
    "desdic/greyjoy.nvim",
    keys = {
        { "<Leader>gr", "<cmd>GreyjoyTelescope<CR>", desc = "[G]reyjoy [r]un" },
        -- { "<Leader>gr", "<cmd>Greyjoy<CR>", desc = "[G]reyjoy [r]un" },
        { "<Leader>gg", "<cmd>Greyjoy fast<CR>", desc = "[G]reyjoy fast [g]roup" },
        { "<Leader>ge", "<cmd>Greyedit<CR>", desc = "[G]reyjoy [r]un" },
    },
    dependencies = {
        { "akinsho/toggleterm.nvim" },
    },
    cmd = { "Greyjoy", "Greyedit", "GreyjoyTelescope" },
    config = function()
        local greyjoy = require("greyjoy")
        local condition = require("greyjoy.conditions")
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
                        ["zig build"] = {
                            command = { "zig", "build" },
                            filetype = "zig",
                        },
                        ["cmake --build target"] = {
                            command = { "cd", "{rootdir}", "&&", "cmake", "--build", "{rootdir}/target" },
                            condition = function(n)
                                return condition.file_exists("CMakeLists.txt", n)
                                    and condition.directory_exists("target", n)
                            end,
                        },
                        ["cmake -S . -B target"] = {
                            command = { "cd", "{rootdir}", "&&", "cmake", "-S", ".", "-B", "{rootdir}/target" },
                            condition = function(n)
                                return condition.file_exists("CMakeLists.txt", n)
                                    and not condition.directory_exists("target", n)
                            end,
                        },
                        ["build-login"] = {
                            command = { "kitchenlogin.sh" },
                            condition = function(n)
                                return condition.directory_exists("kitchen-build/.kitchen", n)
                            end,
                        },
                    },
                },
                kitchen = {
                    group_id = 2,
                    targets = { "converge", "verify", "destroy", "test", "login" },
                    include_all = false,
                },
                docker_compose = { group_id = 3 },
                cargo = { group_id = 4 },
            },
            run_groups = { fast = { "generic", "makefile", "cargo", "docker_compose" } },
        })

        greyjoy.load_extension("generic")
        greyjoy.load_extension("makefile")
        greyjoy.load_extension("kitchen")
        greyjoy.load_extension("cargo")
        greyjoy.load_extension("docker_compose")
    end,
}
