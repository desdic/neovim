return {
    "desdic/greyjoy.nvim",
    keys = {
        { "<leader>gr", "<cmd>Greyjoy<CR>", desc = "[G]reyjoy [r]un" },
        { "<leader>gg", "<cmd>Greyjoy fast<CR>", desc = "[G]reyjoy fast [g]roup" },
        {
            "<leader>rl",
            "<cmd>GreyjoyRunLast<CR>",
            desc = "Run last greyjoy",
        },
    },
    cmd = { "Greyjoy", "Greyedit", "GreyjoyRunLast" },
    config = function()
        local greyjoy = require("greyjoy")
        local condition = require("greyjoy.conditions")

        local tmpmakename = nil

        local pre_make = function(command)
            tmpmakename = os.tmpname()
            table.insert(command.command, "2>&1")
            table.insert(command.command, "|")
            table.insert(command.command, "tee")
            table.insert(command.command, tmpmakename)
        end

        -- A bit hacky solution to checking when tee has flushed its file
        local post_make = function()
            vim.cmd(":cexpr []")
            local cmd = { "inotifywait", "-e", "close_write", tmpmakename }

            local job_id = vim.fn.jobstart(cmd, {
                stdout_buffered = true,
                on_exit = function(_, _, _)
                    if tmpmakename ~= nil then
                        vim.cmd(":cgetfile " .. tmpmakename)
                        os.remove(tmpmakename)
                    end
                end,
            })

            if job_id <= 0 then
                vim.notify("Failed to start inotifywait!")
            end
        end

        greyjoy.setup({
            ui = {
                term = {
                    height = 10,
                },
            },
            output_results = require("greyjoy.terminals").term,
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
                        ["cmake --build build"] = {
                            command = { "cd", "{rootdir}", "&&", "cmake", "--build", "{rootdir}/build" },
                            condition = function(n)
                                return condition.file_exists("CMakeLists.txt", n)
                                    and condition.directory_exists("build", n)
                            end,
                        },
                        ["cmake -S . -B build"] = {
                            command = { "cd", "{rootdir}", "&&", "cmake", "-S", ".", "-B", "{rootdir}/build" },
                            condition = function(n)
                                return condition.file_exists("CMakeLists.txt", n)
                                    and not condition.directory_exists("build", n)
                            end,
                        },
                        ["build-login"] = {
                            command = { "kitchenlogin.sh" },
                            condition = function(n)
                                return condition.directory_exists("kitchen-build/.kitchen", n)
                            end,
                        },
                        ["build-deb jammy"] = {
                            command = { "build-deb.sh", "jammy" },
                            condition = function(n)
                                return condition.file_exists("debian/changelog", n)
                            end,
                        },
                    },
                },
                kitchen = {
                    targets = { "converge", "verify", "destroy", "test", "login" },
                    include_all = false,
                },
                docker_compose = {},
                cargo = {},
                makefile = {
                    pre_hook = pre_make,
                    post_hook = post_make,
                },
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
