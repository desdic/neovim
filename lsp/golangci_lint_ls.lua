return {
    cmd = { "golangci-lint-langserver" },
    filetypes = { "go", "gomod" },
    init_options = {
        command = {
            "golangci-lint",
            "run",
            "--output.json.path=stdout",
            "--show-stats=false",
            "--concurrency=8",
            "--config=~/.config/golangci/golangci.yaml",
        },
    },
}
