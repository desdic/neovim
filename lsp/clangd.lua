return {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--fallback-style=none",
        "--function-arg-placeholders=false",
    },
    root_markers = { "compile_commands.json", "compile_flags.txt", ".clang-format", ".clangd" },
    filetypes = { "c", "cpp" },
}
