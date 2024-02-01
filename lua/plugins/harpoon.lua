return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()

        vim.keymap.set("n", "<leader>fa", function()
            harpoon:list():append()
        end)
        vim.keymap.set("n", "<leader>fe", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end)

        for i = 1, 5 do
            vim.keymap.set("n", "<Leader>" .. i, function()
                harpoon:list():select(i)
            end)
        end
    end,
}
