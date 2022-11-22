local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") ..
                             "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({
            "git", "clone", "--depth", "1",
            "https://github.com/wbthomason/packer.nvim", install_path
        })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then return end

packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({border = "rounded"})
        end
    }
})

return packer.startup({
    function(use)
        use("wbthomason/packer.nvim")

        use("lewis6991/impatient.nvim")

        -- used by other plugins
        use("nvim-lua/plenary.nvim")
        use("kyazdani42/nvim-web-devicons")
        use("rcarriga/nvim-notify")

        -- stabilize cursor after open/close
        -- no longer neede in 0.9 or nightly due to
        -- set splitkeep=screen
        use("luukvbaal/stabilize.nvim")

        -- rainbow ({[]})
        use("p00f/nvim-ts-rainbow")

        -- quoting
        use("windwp/nvim-autopairs")

        use({
            "nvim-treesitter/nvim-treesitter",
            run = function()
                require("nvim-treesitter.install").update({with_sync = true})
            end
        })

        use("nvim-treesitter/nvim-treesitter-refactor")
        use("nvim-treesitter/nvim-treesitter-textobjects")
        use("nvim-treesitter/nvim-treesitter-context")
        use("JoosepAlviste/nvim-ts-context-commentstring")
        use("nvim-treesitter/playground")

        use("SmiteshP/nvim-navic")

        -- clipboard manager
        use("AckslD/nvim-neoclip.lua")

        use({"phaazon/hop.nvim", branch = "v2"})
        use("ggandor/leap.nvim")
        use("ggandor/leap-spooky.nvim")
        use("gpanders/editorconfig.nvim") -- use editorconfig
        use("Vimjas/vim-python-pep8-indent") -- python indentenation
        use("numToStr/Comment.nvim") -- commenting
        use("beauwilliams/focus.nvim") -- focus active window

        -- Theming
        use({"catppuccin/nvim", as = "catppuccin"}) -- color theme

        use("nvim-lualine/lualine.nvim")
        use("akinsho/nvim-bufferline.lua")
        use("neovim/nvim-lspconfig")

        use("williamboman/mason.nvim")
        use("williamboman/mason-lspconfig.nvim")
        use("jayp0521/mason-null-ls.nvim")

        use({
            "jose-elias-alvarez/null-ls.nvim",
            run = {
                "go install github.com/daixiang0/gci@latest",
                "go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest",
                "go install golang.org/x/tools/cmd/goimports@latest"
            }
        })
        use("nvim-telescope/telescope-fzy-native.nvim")
        use("nvim-telescope/telescope-media-files.nvim")
        use("nvim-telescope/telescope.nvim")
        use("nvim-telescope/telescope-ui-select.nvim")

        use("ray-x/lsp_signature.nvim")

        use("kshenoy/vim-signature")
        use("lewis6991/gitsigns.nvim")

        use("hrsh7th/nvim-cmp") -- The completion plugin
        use("hrsh7th/cmp-buffer") -- buffer completions
        use("hrsh7th/cmp-path") -- path completions
        use("hrsh7th/cmp-cmdline") -- cmdline completions
        use("L3MON4D3/LuaSnip") -- snippet completions
        use("hrsh7th/cmp-nvim-lsp")
        use("hrsh7th/cmp-nvim-lua")
        use({"glepnir/lspsaga.nvim", branch = "main"})
        use("onsails/lspkind.nvim")

        use("rafamadriz/friendly-snippets")

        use("saadparwaiz1/cmp_luasnip")

        -- terminal
        use("akinsho/toggleterm.nvim")

        -- splash
        use("goolord/alpha-nvim")

        -- Development/debug
        use("ray-x/go.nvim")
        use("mfussenegger/nvim-dap")
        use("rcarriga/nvim-dap-ui")
        use("theHamsta/nvim-dap-virtual-text")
        use({"ray-x/guihua.lua", run = "cd lua/fzy && make"})
        use("mfussenegger/nvim-dap-python")
        use("leoluz/nvim-dap-go")

        -- UI
        use("stevearc/dressing.nvim")

        use("kylechui/nvim-surround")

        use("nvim-tree/nvim-tree.lua")

        use("desdic/greyjoy.nvim")

        use("ThePrimeagen/harpoon")

        -- Markdown rendering
        use({"toppair/peek.nvim", run = "deno task --quiet build:fast"})

        use("ziontee113/neo-minimap")

        use("booperlv/nvim-gomove")

        -- run sync on installation
        if packer_bootstrap then require("packer").sync() end
    end,
    config = {python_cmd = "python3"}
})
