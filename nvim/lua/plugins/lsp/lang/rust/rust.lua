return {
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			local lsp_name = "rust_analyzer"
			local common = require("plugins.lsp.global.common")

			opts.rust_analyzer = {
				on_attach = function(client, bufnr)
					common.setup(client, bufnr)
				end,
				capabilities = common.make_capabilities(),
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

			if vim.g.IS_NIX then
				vim.lsp.config(lsp_name, opts.rust_analyzer)
				vim.lsp.enable(lsp_name)
			end
			return opts
		end,
	},
}
