local M = {
	"folke/flash.nvim",
	event = "VeryLazy",

	opts = {
		jump = { autojump = false },
		modes = {
			search = {
				enabled = false,
				highlight = {
					backdrop = true,
				},
			},
		},
		prompt = { enabled = false },
	},

	config = function(_, opts)
		require("flash").setup(opts)
	end,
	keys = function()
		return {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump({
						search = {
							multi_window = false,
							mode = function(str)
								return "\\<" .. str
							end,
						},
					})
				end,
				desc = "flash jump",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "flash jump treesitter",
			},
		}
	end,
}

return M
