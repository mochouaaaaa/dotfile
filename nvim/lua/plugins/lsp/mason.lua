return {
	{
		"mason-org/mason.nvim",
		enabled = not vim.g.IS_NIX,
		opts = {
			automatic_installation = not vim.g.IS_NIX,
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		enabled = not vim.g.IS_NIX,
	},
}
