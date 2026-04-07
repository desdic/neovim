vim.pack.add({
    { src = "https://github.com/iamcco/markdown-preview.nvim" },
}, { confirm = false })

vim.g.mkdp_filetypes = { "markdown" }

vim.api.nvim_create_autocmd({ "PackChanged" }, {
    group = vim.api.nvim_create_augroup("MarkdownPreviewUpdated", { clear = true }),
    callback = function(args)
        local spec = args.data.spec
        if spec and spec.name == "markdown-preview" and args.data.kind == "update" then
            vim.notify("markdown-preview was updated, running :TSUpdate", vim.log.levels.INFO)
            vim.schedule(function()
                vim.system({ "cd", "app", "&&", "yarn", "install" })
            end)
        end
    end,
})
