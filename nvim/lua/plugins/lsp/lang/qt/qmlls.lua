return {
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		opts = function(_, opts)
			local lsp_name = "qmlls"
			local common = require("plugins.lsp.global.common")

			opts.qmlls = {
				on_attach = function(client, bufnr)
					common.setup(client, bufnr)
				end,
				capabilities = common.make_capabilities(),
			}

			if vim.g.IS_NIX then
				vim.lsp.config(lsp_name, opts.lua_ls)
				vim.lsp.enable(lsp_name)
			end
			return opts
		end,
	},
}
