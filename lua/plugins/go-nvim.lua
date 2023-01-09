local M = { "ray-x/go.nvim", ft = "go", dependencies = { "ray-x/guihua.lua" } }

function M.config() require("go").setup({ dap_debug = true, dap_debug_gui = true }) end

return M
