return {
    "desdic/marlin.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        open_callback = require("marlin.callbacks").use_split,
        patterns = { ".git", ".svn", "Makefile", "Cargo.toml", "." },
    },
    keys = {
        {
            "<leader>0",
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

        keymap("n", "<leader>fa", function()
            marlin.add()
        end, { desc = "add file" })
        keymap("n", "<leader>fd", function()
            marlin.remove()
            vim.cmd("bdelete")
        end, { desc = "remove file" })
        keymap("n", "<leader>f]", function()
            marlin.move_up()
        end, { desc = "move up" })
        keymap("n", "<leader>f[", function()
            marlin.move_down()
        end, { desc = "move down" })
        keymap("n", "<leader>fs", function()
            marlin.sort()
        end, { desc = "sort" })
        keymap("n", "<leader>z", function()
            marlin.toggle()
        end, { desc = "toggle" })

        keymap("n", "<leader>fx", function()
            local results = require("marlin").get_indexes()
            local content = {}

            local fzf_lua = require("fzf-lua")
            local builtin = require("fzf-lua.previewer.builtin")
            local fzfpreview = builtin.buffer_or_file:extend()

            function fzfpreview:new(o, opts, fzf_win)
                fzfpreview.super.new(self, o, opts, fzf_win)
                setmetatable(self, fzfpreview)
                return self
            end

            function fzfpreview.parse_entry(_, entry_str)
                if entry_str == "" then
                    return {}
                end

                local entry = content[entry_str]
                return {
                    path = entry.filename,
                    line = entry.row or 1,
                    col = 1,
                }
            end

            fzf_lua.fzf_exec(function(fzf_cb)
                for i, b in ipairs(results) do
                    local entry = i .. ":" .. b.filename .. ":" .. b.row

                    content[entry] = b
                    fzf_cb(entry)
                end
                fzf_cb()
            end, {
                previewer = fzfpreview,
                prompt = "Marlin> ",
                actions = {
                    ["ctrl-d"] = {
                        fn = function(selected)
                            print(selected)
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
            keymap("n", "<leader>" .. index, function()
                marlin.open(index, { use_split = true })
            end, { desc = "goto " .. index })
        end
    end,
}
