local is_nix = vim.env.IS_NIX == "1" or vim.g.IS_NIX == 1 or vim.g.IS_NIX == true

return {
	{
		"mason-org/mason.nvim",
		enabled = not is_nix,
		opts = {
			automatic_installation = not is_nix,
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		enabled = not is_nix,
	},
}
