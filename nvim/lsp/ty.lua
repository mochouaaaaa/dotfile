return {
	on_attach = function(client, bufnr)
		vim.lsp.codelens.enable()
	end,
	settings = {
		ty = {
			inlayHints = {
				variableTypes = true,
				callArgumentNames = true,
			},
			diagnosticMode = "workspace",
			typeCheckingMode = "standard",
		},
	},
}
