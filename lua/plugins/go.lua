vim.pack.add({
    { src = "https://github.com/ray-x/go.nvim", load = false },
    { src = "https://github.com/ray-x/guihua.lua", load = false },
}, { confirm = false })

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

local go_load_group = vim.api.nvim_create_augroup("LazyLoadGo", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = go_load_group,
    pattern = { "go", "gomod", "gosum" },
    callback = function()
        -- Guard clause: if already loaded, don't run again
        if vim.g.go_nvim_loaded then
            return
        end

        vim.cmd("packadd go.nvim")

        require("go").setup({
            lsp_inlay_hints = { enable = false },
            diagnostic = false,
        })

        vim.g.go_nvim_loaded = true
    end,
})
