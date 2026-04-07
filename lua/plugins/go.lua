vim.pack.add({
    { src = "https://github.com/ray-x/go.nvim" },
}, { confirm = false })

vim.defer_fn(function()
    require("go").setup({
        dap_debug = true,
        dap_debug_gui = true,
        lsp_inlay_hints = { enable = false },
        diagnostic = false,
    })

    vim.api.nvim_create_autocmd({ "PackChanged" }, {
        group = vim.api.nvim_create_augroup("XRayGoUpdated", { clear = true }),
        callback = function(args)
            local spec = args.data.spec
            if spec and spec.name == "go.nvim" and args.data.kind == "update" then
                vim.notify("x-ray/go was updated, running update_all_sync", vim.log.levels.INFO)
                vim.schedule(function()
                    require("go.install").update_all_sync()
                end)
            end
        end,
    })
end, 500)
