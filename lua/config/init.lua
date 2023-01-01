return {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 }, -- color scheme
    "rcarriga/nvim-notify", -- notifier
    "nvim-lua/plenary.nvim", -- lua functions for other plugins
    { "kyazdani42/nvim-web-devicons", config = { default = true } }, -- font icons
    "neovim/nvim-lspconfig", -- LSP config
    "williamboman/mason.nvim", -- installer for LSP servers
    "williamboman/mason-lspconfig.nvim", -- easy setup for LSP servers
    "jayp0521/mason-null-ls.nvim", -- Mason integration with null-ls
    { "ray-x/lsp_signature.nvim", dependencies = { "neovim/nvim-lspconfig" } }, { "glepnir/lspsaga.nvim", branch = "main" }, -- UI for diagnostics
    "goolord/alpha-nvim" -- start screen
}
