return {
	on_attach = function(client, bufnr)
		vim.lsp.codelens.enable()
	end,

	settings = {
		tools = {
			inlay_hints = {
				auto = false,
			},
		},
		cargo = {
			allFeatures = { allFeatures = true },
			proMacro = { enabled = true },
			checkOnSave = { command = "clippy" },
		},
	},
}
