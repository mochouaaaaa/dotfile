local M = {
	"danymat/neogen",
	dependencies = "nvim-treesitter/nvim-treesitter",
	opts = {
		enabled = true,
		input_after_comment = true,
		languages = {
			python = {
				template = {
					annotation_convention = "numpydoc",
				},
			},
		},
	},
	keys = function()
		return {
			{
				"<Leader>nc",
				function()
					require("neogen").generate({ type = "class" })
				end,
				desc = "class annotation",
			},
			{
				"<Leader>nf",
				function()
					require("neogen").generate({ type = "func" })
				end,
				desc = "function annotation",
			},
		}
	end,
}

return M
