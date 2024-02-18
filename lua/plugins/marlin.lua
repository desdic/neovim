return {
    "desdic/marlin.nvim",
    opts = {
        open_callback = require("marlin.callbacks").use_split,
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

        for index = 1, 4 do
            keymap("n", "<Leader>" .. index, function()
                marlin.open(index, { use_split = true })
            end, { desc = "goto " .. index })
        end
    end,
}
