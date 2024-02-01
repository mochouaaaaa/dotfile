local env = require("plugins.configs.virtual_env")

vim.g.loaded_python3_provider = 1

return {
	pyright = {
		disableLanguageServices = false,
		disableOrganizeImports = false,
	},
	python = {
		analysis = {
			autoSearchPaths = true,
			autoImportCompletions = true,
			useLibraryCodeForTypes = true,
			diagnosticMode = "workspace",
			-- diagnosticMode = "openFilesOnly",
			diagnosticSeverityOverrides = {
				-- https://microsoft.github.io/pyright/#/configuration?id=diagnostic-rule-defaults
				reportMissingImports = "error",
				reportUndefinedVariable = "none",
			},
			strictListInference = true,
			strictDictionaryInference = true,
			strictSetInference = true,
			typeCheckingMode = "basic",
		},
		inlayHints = {
			functionReturnTypes = true,
			variableTypes = true,
		},
		pythonPath = { env.python_env() },
	},
}
