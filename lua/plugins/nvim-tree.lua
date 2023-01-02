local M = { "nvim-tree/nvim-tree.lua", keys = { { "<Leader>n", ":NvimTreeToggle<CR>", desc = "Start file browser" } } }

function M.config()
    -- recommended settings from nvim-tree documentation
    vim.g.loaded = 1
    vim.g.loaded_netrwPlugin = 1

    -- change color for arrows in tree to light blue
    -- vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

    -- configure nvim-tree
    require("nvim-tree").setup({
        renderer = { icons = { glyphs = { folder = { arrow_closed = "", arrow_open = "" } } } },
        actions = { open_file = { window_picker = { enable = false } } }
    })
end

return M
