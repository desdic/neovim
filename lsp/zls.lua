return {
    cmd = { "zls" },
    filetypes = { "zig", "zir" },
    workspace_required = false,
    root_markers = { "zls.json", "build.zig", ".git" },
    single_file_support = true,
    settings = {
        zls = {
            -- Whether to enable build-on-save diagnostics
            --
            -- Further information about build-on save:
            -- https://zigtools.org/zls/guides/build-on-save/
            enable_build_on_save = true,

            -- Neovim already provides basic syntax highlighting
            semantic_tokens = "partial",

            -- omit the following line if `zig` is in your PATH
            zig_exe_path = "/sbin/zig",
        },
    },
}
