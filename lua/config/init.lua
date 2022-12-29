return {
    {"catppuccin/nvim", name = "catppuccin", priority = 1000}, -- color scheme
    "nvim-lua/plenary.nvim", -- lua functions for other plugins
    -- {"stevearc/dressing.nvim", event = "VeryLazy"}, -- UI used by plugins
    "kyazdani42/nvim-web-devicons", -- font icons
    {"ray-x/guihua.lua", build = "cd lua/fzy && make"}, -- LUA gui
    "rcarriga/nvim-notify", -- notifier
    "windwp/nvim-autopairs", -- pair quotes and brackets
    "nvim-lualine/lualine.nvim", -- status line
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
    "Vimjas/vim-python-pep8-indent", -- python indentenation
    "numToStr/Comment.nvim", -- commenting
    "beauwilliams/focus.nvim", -- focus active window
    "neovim/nvim-lspconfig", -- LSP config
    {"SmiteshP/nvim-navic", dependencies = {"neovim/nvim-lspconfig"}}, -- statusline/winbar LSP
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
    }, "nvim-telescope/telescope.nvim", -- fast navigation
    "nvim-telescope/telescope-fzy-native.nvim", "nvim-telescope/telescope-ui-select.nvim",
    "desdic/telescope-rooter.nvim", {"AckslD/nvim-neoclip.lua", dependencies = {"nvim-telescope/telescope.nvim"}},
    {"ray-x/lsp_signature.nvim", dependencies = {"neovim/nvim-lspconfig"}}, "kshenoy/vim-signature",
    "lewis6991/gitsigns.nvim", "hrsh7th/nvim-cmp", -- The completion plugin
    "hrsh7th/cmp-buffer", -- buffer completions
    "hrsh7th/cmp-path", -- path completions
    "hrsh7th/cmp-cmdline", -- cmdline completions
    "L3MON4D3/LuaSnip", -- snippet completions
    "hrsh7th/cmp-nvim-lsp", -- completion using LSP
    "hrsh7th/cmp-nvim-lua", -- Lua completion
    {"glepnir/lspsaga.nvim", branch = "main"}, -- UI for diagnostics
    "onsails/lspkind.nvim", -- pictograms for LSP
    "rafamadriz/friendly-snippets", -- collection of snippets
    "saadparwaiz1/cmp_luasnip", -- snippet engine in lua
    "akinsho/toggleterm.nvim", -- terminal
    "goolord/alpha-nvim", -- start screen
    "nvim-tree/nvim-tree.lua", -- file browsing
    "ThePrimeagen/harpoon", -- marks but better
    "ziontee113/neo-minimap" -- treesitter queries
}
