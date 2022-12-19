local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
    vim.notify("Unable to require nvim-tree", vim.lsp.log_levels.ERROR, {title = "Plugin error"})
    return
end

-- recommended settings from nvim-tree documentation
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

-- change color for arrows in tree to light blue
-- vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

-- configure nvim-tree
nvimtree.setup({
    renderer = {icons = {glyphs = {folder = {arrow_closed = "", arrow_open = ""}}}},
    actions = {open_file = {window_picker = {enable = false}}}
})

-- Nvim-tree
vim.keymap.set("n", "<Leader>n", ":NvimTreeToggle<CR>", {noremap = true, silent = true, desc = "Start file browser"})
