return {
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			local common = require("plugins.lsp.global.common")

			opts.jsonls = {
				on_attach = function(client, bufnr)
					common.setup(client, bufnr)
				end,
				capabilities = common.make_capabilities(),
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
						format = {
							enable = true,
						},
					},
				},
			}

			if vim.g.IS_NIX then
				local lspconfig = require("lspconfig")
				lspconfig.jsonls.setup(opts.jsonls)
			end
			return opts
		end,
	},
}
