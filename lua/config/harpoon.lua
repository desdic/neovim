local M = {
    "ThePrimeagen/harpoon",
    cmd = "Harpoon",
    config = {},
    keys = {
        { "<Leader>a", ":Harpoon add_file<CR>", desc = "Add file to harpoon" },
        { "<Leader>/", ":Harpoon nav_next<CR>", desc = "Next file in harpoon" },
        { "<Leader>.", ":Harpoon nav_prev<CR>", desc = "Previous file in harpoon" },
        { "<Leader>1", ":Harpoon file1<CR>", desc = "file 1" }, { "<Leader>2", ":Harpoon file2<CR>", desc = "file2" },
        { "<Leader>3", ":Harpoon file3<CR>", desc = "file 3" }, { "<Leader>4", ":Harpoon file4<CR>", desc = "file 4" }
    }
}

function M.init()
    vim.api.nvim_create_user_command("Harpoon", function(args)
        if args.args == "add_file" then
            require("harpoon.mark").add_file()
        elseif args.args == "nav_next" then
            require("harpoon.ui").nav_next()
        elseif args.args == "nav_prev" then
            require("harpoon.ui").nav_prev()
        elseif args.args == "nav_prev" then
            require("harpoon.ui").nav_prev()
        elseif args.args == "file1" then
            require("harpoon.ui").nav_file(1)
        elseif args.args == "file2" then
            require("harpoon.ui").nav_file(2)
        elseif args.args == "file3" then
            require("harpoon.ui").nav_file(3)
        elseif args.args == "file4" then
            require("harpoon.ui").nav_file(4)
        end
    end, { nargs = "*", desc = "Run harpoon" })
end

return M
