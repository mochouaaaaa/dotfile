local common = require("util.lsp")

return {
	{
		on_attach = function(client, bufnr)
			common.setup(client, bufnr)
			-- if client.name == "ruff" then
			-- 	client.server_capabilities.hoverProvider = false
			-- end
		end,
		capabilities = common.make_capabilities(),
		settings = {
			basedpyright = {
				disableLanguageServices = false,
				disableOrganizeImports = false,
				completion = {
					importSupport = true,
				},
				typeCheckingMode = "standard",
				reportAttributeAccessIssue = "none",
			},
			python = {
				analysis = {
					autoSearchPaths = true,
					autoImportCompletions = true,
					diagnosticMode = "workspace",
					strictListInference = true,
					strictDictionaryInference = true,
					strictSetInference = true,
					useLibraryCodeForTypes = true,
					reportAny = "off",
					reportAssignmentType = "none",
					reportMissingTypeStubs = "off",
					reportUnusedCallResult = "off",
					reportUnknownValerType = "off",
					reportImplicitStringConcatenation = "off",
					reportAttributeAccessIssue = "none",
				},
				inlayHints = {
					functionReturnTypes = true,
					variableTypes = true,
				},
			},
		},
	},
}
