return {
    cmd = { "solargraph", "stdio" },
    settings = {
        solargraph = {
            diagnostics = true,
        },
    },
    init_options = { formatting = true },
    filetypes = { "ruby", "eruby", "rakefile" },
    root_markers = { "Gemfile", ".git" },
}
