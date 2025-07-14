local common = require("plugins.lsp.global.common")

return {
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.ruff = {
				init_options = {
					settings = {
						logLevel = "error",
					},
				},
			}
			opts.basedpyright = {
				on_attach = function(client, bufnr)
					common.setup(client, bufnr)
					client.server_capabilities.hoverProvider = false
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
			}

			if vim.g.IS_NIX then
				local lspconfig = require("lspconfig")
				lspconfig.basedpyright.setup(opts.basedpyright)
			end
		end,
	},
}
