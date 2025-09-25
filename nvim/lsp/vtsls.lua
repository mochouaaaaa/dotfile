local common = require("util.lsp")

return {
	on_attach = function(client, bufnr)
		common.setup(client, bufnr)
	end,
	capabilities = common.make_capabilities(),
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"vue",
	},
	settings = {
		vtsls = {
			tsserver = {
				enableMoveToFileCodeAction = true,
				autoUseWorkspaceTsdk = true,
				experimental = {
					completion = {
						enableServerSideFuzzyMatch = true,
					},
				},
				typescript = {
					updateImportsOnFileMove = {
						enabled = "always",
					},
					suggest = {
						completeFunctionCalls = true,
					},
					inlayHints = {
						parameterNames = { enabled = "literals" },
						parameterTypes = { enabled = false },
						variableTypes = { enabled = false },
						propertyDeclarationTypes = { enabled = true },
						functionLikeReturnTypes = { enabled = false },
						enumMemberValues = { enabled = true },
					},
				},
				javascript = {
					updateImportsOnFileMove = {
						enabled = "always",
					},
					inlayHints = {
						parameterNames = { enabled = "literals" },
						parameterTypes = { enabled = false },
						variableTypes = { enabled = false },
						propertyDeclarationTypes = { enabled = true },
						functionLikeReturnTypes = { enabled = false },
						enumMemberValues = { enabled = true },
					},
				},
				globalPlugins = {
					{
						name = "@vue/typescript-plugin",
						location = vim.fs.root(vim.fn.exepath("vue-language-server"), "bin")
							.. "/lib/language-tools/packages/language-server",
						languages = { "vue" },
						configNamespace = "typescript",
						enableForWorkspaceTypeScriptVersions = true,
					},
				},
			},
		},
	},
}
