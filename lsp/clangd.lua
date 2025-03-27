return {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
    },
    root_markers = { "compile_commands.json", "compile_flags.txt" },
    filetypes = { "c", "cpp" },
}
