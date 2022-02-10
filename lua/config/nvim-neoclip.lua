local ok, neoclip = pcall(require, "neoclip")
if not ok then
    vim.notify("Unable to require neoclip", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

neoclip.setup()

local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}
keymap("n", "<Leader>bp", ":Telescope neoclip unnamed<CR>", opts)
