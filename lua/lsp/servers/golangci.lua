local lspconfig = require 'lspconfig'
local go = require "nvim-lsp-installer.installers.go"
local server = require 'nvim-lsp-installer.server'

local M = {}
local server_name = 'golangci_lint_ls'

local root_dir = server.get_server_root_path(server_name)

function M.get_server()
	return server.Server:new {
		name = server_name,
		root_dir = root_dir,
		languages = { "go" },
		filetypes = { "go" },
		homepage = "https://github.com/nametake/golangci-lint-langserver",
		installer = go.packages { "github.com/nametake/golangci-lint-langserver", "github.com/golangci/golangci-lint/cmd/golangci-lint@v1.42.1" },
		default_options = {},
	}
end

function M.get_opts()
	return {
		root_dir = function(fname)
			return lspconfig.util.find_git_ancestor(fname) or vim.loop.os_homedir()
		end;
		cmd = { go.executable(root_dir, "golangci-lint" ), "run" },
		filetypes = { 'go', 'gomod' },
		settings = {},
	}
end

return M
