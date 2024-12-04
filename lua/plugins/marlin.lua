return {
    "desdic/marlin.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        open_callback = require("marlin.callbacks").use_split,
        patterns = { ".git", ".svn", "Makefile", "Cargo.toml", "." },
    },
    keys = {
        {
            "<Leader>0",
            function()
                require("marlin").open_all()
            end,
            { desc = "open all" },
        },
    },
    config = function(_, opts)
        local marlin = require("marlin")
        marlin.setup(opts)
        local keymap = vim.keymap.set

        keymap("n", "<Leader>fa", function()
            marlin.add()
        end, { desc = "add file" })
        keymap("n", "<Leader>fd", function()
            marlin.remove()
            vim.cmd("bdelete")
        end, { desc = "remove file" })
        keymap("n", "<Leader>f]", function()
            marlin.move_up()
        end, { desc = "move up" })
        keymap("n", "<Leader>f[", function()
            marlin.move_down()
        end, { desc = "move down" })
        keymap("n", "<Leader>fs", function()
            marlin.sort()
        end, { desc = "sort" })
        keymap("n", "<Leader>z", function()
            marlin.toggle()
        end, { desc = "toggle" })

        keymap("n", "<Leader>fx", function()
            local results = require("marlin").get_indexes()
            local content = {}

            require("fzf-lua").fzf_exec(function(fzf_cb)
                for i, b in ipairs(results) do
                    local entry = i .. ":" .. b.filename .. ":" .. b.row

                    content[entry] = b
                    fzf_cb(entry)
                end
                fzf_cb()
            end, {
                prompt = "Marlin> ",
                actions = {
                    ["ctrl-d"] = {
                        fn = function(selected)
                            require("marlin").remove(content[selected[1]].filename)
                        end,
                        reload = true,
                        silent = true,
                    },
                    ["ctrl-k"] = {
                        fn = function(selected)
                            require("marlin").move_up(content[selected[1]].filename)
                        end,
                        reload = true,
                        silent = false,
                    },
                    ["ctrl-j"] = {
                        fn = function(selected)
                            print(vim.inspect(selected))

                            require("marlin").move_down(content[selected[1]].filename)
                        end,
                        reload = true,
                        silent = false,
                    },
                },
            })
        end, { desc = "fzf marlin" })

        for index = 1, 4 do
            keymap("n", "<Leader>" .. index, function()
                marlin.open(index, { use_split = true })
            end, { desc = "goto " .. index })
        end
    end,
}
