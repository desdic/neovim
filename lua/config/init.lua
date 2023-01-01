return {
    {"catppuccin/nvim", name = "catppuccin", priority = 1000}, -- color scheme
    "nvim-lua/plenary.nvim", -- lua functions for other plugins
    "kyazdani42/nvim-web-devicons", -- font icons
    {"ray-x/guihua.lua", build = "cd lua/fzy && make"}, -- LUA gui
    "rcarriga/nvim-notify", -- notifier
    "gpanders/editorconfig.nvim", -- use editorconfig
    "neovim/nvim-lspconfig", -- LSP config
    "williamboman/mason.nvim", -- installer for LSP servers
    "williamboman/mason-lspconfig.nvim", -- easy setup for LSP servers
    "jayp0521/mason-null-ls.nvim", -- Mason integration with null-ls
    {
        "jose-elias-alvarez/null-ls.nvim", -- formatting
        build = {
            "go install github.com/daixiang0/gci@latest",
            "go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest",
            "go install golang.org/x/tools/cmd/goimports@latest"
        }
    }, {"ray-x/lsp_signature.nvim", dependencies = {"neovim/nvim-lspconfig"}}, "kshenoy/vim-signature",
    {"glepnir/lspsaga.nvim", branch = "main"}, -- UI for diagnostics
    "goolord/alpha-nvim" -- start screen
}
