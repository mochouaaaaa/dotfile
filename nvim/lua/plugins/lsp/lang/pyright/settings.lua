local env = require("plugins.configs.virtual_env")

vim.g.loaded_python3_provider = 1

return {
	pyright = {
		disableLanguageServices = false,
		disableOrganizeImports = true,
		completion = {
			importSupport = true,
		},
	},
	python = {
		analysis = {
			autoSearchPaths = true,
			autoImportCompletions = true,
			useLibraryCodeForTypes = true,
			diagnosticMode = "workspace",
			strictListInference = true,
			strictDictionaryInference = true,
			strictSetInference = true,
			typeCheckingMode = "off",
		},
		inlayHints = {
			functionReturnTypes = true,
			variableTypes = true,
		},
		-- pythonPath = { env.python_env() },
	},
}
