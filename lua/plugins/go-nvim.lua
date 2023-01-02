local M = { "ray-x/go.nvim", ft = "go" }

function M.config()
    require("go").setup({ dap_debug = true, dap_debug_gui = true })

    vim.api.nvim_create_autocmd({ "BufWritePre" },
        { pattern = "*.go", callback = function() require("go.format").goimport() end })
end

return M
