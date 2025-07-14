return {
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
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
				local lspconfig = require("lspconfig")
				lspconfig.rust_analyzer.setup(opts.rust_analyzer)
			end
		end,
	},
}
