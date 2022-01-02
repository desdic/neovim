return {
	cmd = {"node", DATA_PATH .. "/lsp_servers/python/node_modules/pyright/langserver.index.js", "--stdio"},
	settings = {
		python = {
			analysis = { autoSearchPaths = true, diagnosticMode = "openFilesOnly", useLibraryCodeForTypes = true,},
		}
	}
}
