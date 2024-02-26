return {
    "desdic/marlin.nvim",
    opts = {
        open_callback = require("marlin.callbacks").use_split,
        patterns = { ".git", ".svn", "Makefile", "Cargo.toml", "." },
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
        keymap("n", "<Leader>0", function()
            marlin.open_all()
        end, { desc = "open all" })

        keymap("n", "<Leader>fx", function()
            local conf = require("telescope.config").values
            local action_state = require("telescope.actions.state")
            local results = require("marlin").get_indexes()

            local index = 0
            require("telescope.pickers")
                .new({}, {
                    prompt_title = "Marlin",
                    finder = require("telescope.finders").new_table({
                        results = results,
                        entry_maker = function(entry)
                            index = index + 1
                            return {
                                value = entry,
                                ordinal = index .. ":" .. entry.filename,
                                lnum = entry.row,
                                col = entry.col + 1,
                                filename = entry.filename,
                                display = index .. ":" .. entry.filename .. ":" .. entry.row .. ":" .. entry.col,
                            }
                        end,
                    }),
                    previewer = conf.grep_previewer({}),
                    sorter = conf.generic_sorter({}),
                    attach_mappings = function(_, map)
                        map("i", "<c-d>", function(bufnr)
                            local current_picker = action_state.get_current_picker(bufnr)
                            current_picker:delete_selection(function(selection)
                                require("marlin").remove(selection.filename)
                            end)
                        end)
                        return true
                    end,
                })
                :find()
        end, { desc = "Telescope marlin" })

        for index = 1, 4 do
            keymap("n", "<Leader>" .. index, function()
                marlin.open(index, { use_split = true })
            end, { desc = "goto " .. index })
        end
    end,
}
