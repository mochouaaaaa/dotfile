return {
	"nvim-treesitter/nvim-treesitter",
	opts = function(_, opts)
		opts = vim.tbl_deep_extend("force", opts, {
			auto_install = not vim.g.IS_NIX,
			sync_install = not vim.g.IS_NIX,
			ignore_install = {},

			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<CR>",
					node_incremental = "<CR>",
					scope_incremental = false,
					node_decremental = "<S-CR>",
				},
			},
		})
		return opts
	end,
}
