local is_nix = vim.env.IS_NIX == "1" or vim.g.IS_NIX == 1 or vim.g.IS_NIX == true

return {
	"nvim-treesitter/nvim-treesitter",
	opts = function(_, opts)
		opts.ensure_installed = { "lua" }
		if is_nix then
			opts.ensure_installed = {}
		end
	end,
}
