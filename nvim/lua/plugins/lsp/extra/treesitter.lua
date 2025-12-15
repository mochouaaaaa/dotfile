return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		enable = not vim.g.IS_NIX,
		config = function()
			require("nvim-treesitter.configs").setup({
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
		end,
	},
}
