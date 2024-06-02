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

        local mindex = 0
        local generate_finder = function()
            mindex = 0
            return require("telescope.finders").new_table({
                results = require("marlin").get_indexes(),
                entry_maker = function(entry)
                    mindex = mindex + 1
                    return {
                        value = entry,
                        ordinal = mindex .. ":" .. entry.filename,
                        lnum = entry.row,
                        col = entry.col + 1,
                        filename = entry.filename,
                        display = mindex .. ":" .. entry.filename .. ":" .. entry.row .. ":" .. entry.col,
                    }
                end,
            })
        end

        keymap("n", "<Leader>fx", function()
            local conf = require("telescope.config").values
            local action_state = require("telescope.actions.state")

            require("telescope.pickers")
                .new({}, {
                    prompt_title = "Marlin",
                    finder = generate_finder(),
                    previewer = conf.grep_previewer({}),
                    sorter = conf.generic_sorter({}),
                    attach_mappings = function(_, map)
                        map("i", "<c-d>", function(bufnr)
                            local current_picker = action_state.get_current_picker(bufnr)
                            current_picker:delete_selection(function(selection)
                                require("marlin").remove(selection.filename)
                            end)
                        end)
                        map("i", "+", function(bufnr)
                            local current_picker = action_state.get_current_picker(bufnr)
                            local selection = current_picker:get_selection()
                            require("marlin").move_up(selection.filename)
                            current_picker:refresh(generate_finder(), {})
                        end)
                        map("i", "-", function(bufnr)
                            local current_picker = action_state.get_current_picker(bufnr)
                            local selection = current_picker:get_selection()
                            require("marlin").move_down(selection.filename)
                            current_picker:refresh(generate_finder(), {})
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
