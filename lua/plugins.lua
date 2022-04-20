local packer_path = vim.fn.stdpath("data") ..
                        "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
    packer_bootstrap = vim.fn.system({
        "git", "clone", "--depth", "1",
        "https://github.com/wbthomason/packer.nvim", packer_path
    })
    print("Installing packer, close and reopen ...")
    vim.cmd([[packadd packer.nvim]])
end

vim.cmd([[
	augroup packer_user_config
	autocmd!
	autocmd BufWritePost plugins.lua source <afile> | PackerSync
	augroup end
]])

local status_ok, packer = pcall(require, "packer")
if not status_ok then
    print("Unable to require packer")
    return
end

packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({border = "rounded"})
        end
    }
})

return packer.startup({
    function(use)
        use({"wbthomason/packer.nvim"})

        -- used by other plugins
        use({"nvim-lua/plenary.nvim"})
        use({"kyazdani42/nvim-web-devicons"})
        use({"rcarriga/nvim-notify"})

        -- stabilize cursor after open/close
        use({"luukvbaal/stabilize.nvim"})

        -- rainbow ({[]})
        use({"p00f/nvim-ts-rainbow"})

        -- quoting
        use({"windwp/nvim-autopairs"})

        use({"nvim-treesitter/nvim-treesitter-refactor"})
        use({"nvim-treesitter/nvim-treesitter-textobjects"})
        use({"JoosepAlviste/nvim-ts-context-commentstring"})
        use({"windwp/nvim-ts-autotag"})
        use({"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"})
        use({"nvim-treesitter/playground"})

        -- clipboard manager
        use({"AckslD/nvim-neoclip.lua"})

        use({"phaazon/hop.nvim", branch = "v1"})
        use({"gpanders/editorconfig.nvim"}) -- use editorconfig
        use({"Vimjas/vim-python-pep8-indent"}) -- python indentenation
        use({"numToStr/Comment.nvim"}) -- commenting
        use({"beauwilliams/focus.nvim"}) -- focus active window

		-- Theming
        use({"catppuccin/nvim", as = "catppuccin"}) -- color theme
		use({"EdenEast/nightfox.nvim"})
		use({"folke/tokyonight.nvim"})

        use({"nvim-lualine/lualine.nvim"})
        use({"akinsho/nvim-bufferline.lua"})
        use({"kyazdani42/nvim-tree.lua"})
        use({"neovim/nvim-lspconfig"})
        use({"williamboman/nvim-lsp-installer"})
        use({
            "jose-elias-alvarez/null-ls.nvim",
            run = {
                "go install github.com/daixiang0/gci@latest",
                "go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest",
                "go install golang.org/x/tools/cmd/goimports@latest"
            }
        })
        use({"nvim-telescope/telescope-fzy-native.nvim"})
        use({"nvim-telescope/telescope-media-files.nvim"})
        use({"nvim-telescope/telescope.nvim"})
		use({'nvim-telescope/telescope-ui-select.nvim' })
        use({"ray-x/lsp_signature.nvim"})

        use({"kshenoy/vim-signature"})
        use({"lewis6991/gitsigns.nvim"})

        use("hrsh7th/nvim-cmp") -- The completion plugin
        use("hrsh7th/cmp-buffer") -- buffer completions
        use("hrsh7th/cmp-path") -- path completions
        use("hrsh7th/cmp-cmdline") -- cmdline completions
        use("L3MON4D3/LuaSnip") -- snippet completions
        use("hrsh7th/cmp-nvim-lsp")
        use("hrsh7th/cmp-nvim-lua")

        use({"rafamadriz/friendly-snippets"})

        use({"saadparwaiz1/cmp_luasnip"})

		-- terminal
        use({"akinsho/toggleterm.nvim"})

        -- splash
        use({"goolord/alpha-nvim"})

        use({"ahmedkhalf/project.nvim"})

        -- Go development
        use({"ray-x/go.nvim"})
        use({"mfussenegger/nvim-dap"})
        use({"rcarriga/nvim-dap-ui"})
        use({"theHamsta/nvim-dap-virtual-text"})
        use({"ray-x/guihua.lua", run = "cd lua/fzy && make"})

        -- Markdown rendering
        use({"ellisonleao/glow.nvim"})

        -- UI
        use({"stevearc/dressing.nvim"})

        use({"tpope/vim-surround"})
        use({"tpope/vim-fugitive"})

        -- run sync on installation
        if packer_bootstrap then require("packer").sync() end
    end,
    config = {python_cmd = "python3"}
})
