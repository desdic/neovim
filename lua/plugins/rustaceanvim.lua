vim.pack.add({
    { src = "https://github.com/mrcjkb/rustaceanvim", version = vim.version.range("v7.*") },
}, { confirm = false })

vim.g.rustaceanvim = {
    tools = {},
    server = {
        on_attach = function(client, bufnr)
            -- TODO: you can also put keymaps in here
        end,
        default_settings = {
            ["rust-analyzer"] = {},
        },
    },
    -- DAP configuration
    dap = {},
}
