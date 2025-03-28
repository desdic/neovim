return {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
    single_file_support = true,
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                unusedwrite = true,
                nilness = true,
            },
            gofumpt = true,
            semanticTokens = true,
            staticcheck = true,
        },
    },
}
