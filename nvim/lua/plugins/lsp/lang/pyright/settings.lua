local py_env = function()
	local cwd = vim.fn.getcwd()
	if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
		return cwd .. "/venv/bin/python"
	elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
		return cwd .. "/.venv/bin/python"
	else
		return os.getenv("VIRTUAL_ENV") .. "/bin/python"
	end
end

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
		pythonPath = { py_env() },
	},
}
