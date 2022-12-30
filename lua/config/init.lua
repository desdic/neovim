return {
    {"catppuccin/nvim", name = "catppuccin", priority = 1000}, -- color scheme
    "nvim-lua/plenary.nvim", -- lua functions for other plugins
    "kyazdani42/nvim-web-devicons", -- font icons
    {"ray-x/guihua.lua", build = "cd lua/fzy && make"}, -- LUA gui
    "rcarriga/nvim-notify", -- notifier
    {
        "nvim-treesitter/nvim-treesitter",
        build = function() require("nvim-treesitter.install").update({with_sync = true}) end
    }, {"nvim-treesitter/nvim-treesitter-refactor", dependencies = {"nvim-treesitter"}},
    {"nvim-treesitter/nvim-treesitter-textobjects", dependencies = {"nvim-treesitter"}},
    {"nvim-treesitter/nvim-treesitter-context", dependencies = {"nvim-treesitter"}},
    {"JoosepAlviste/nvim-ts-context-commentstring", dependencies = {"nvim-treesitter"}},
    {"nvim-treesitter/playground", dependencies = {"nvim-treesitter"}},
    {"p00f/nvim-ts-rainbow", dependencies = {"nvim-treesitter"}}, -- color scope
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
    "hrsh7th/nvim-cmp", -- The completion plugin
    "hrsh7th/cmp-buffer", -- buffer completions
    "hrsh7th/cmp-path", -- path completions
    "hrsh7th/cmp-cmdline", -- cmdline completions
    "hrsh7th/cmp-nvim-lsp", -- completion using LSP
    "hrsh7th/cmp-nvim-lua", -- Lua completion
    "saadparwaiz1/cmp_luasnip", -- snippet engine in lua
    "L3MON4D3/LuaSnip", -- snippet completions
    {"glepnir/lspsaga.nvim", branch = "main"}, -- UI for diagnostics
    "onsails/lspkind.nvim", -- pictograms for LSP
    "rafamadriz/friendly-snippets", -- collection of snippets
    "akinsho/toggleterm.nvim", -- terminal
    "goolord/alpha-nvim" -- start screen
}
