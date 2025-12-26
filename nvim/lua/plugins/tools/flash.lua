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
		local api, _ = vim.api, vim.fn

		local set_hl = api.nvim_set_hl
		set_hl(0, "FlashLabel", {
			bg = "#ff007c",
			fg = "#c8d3f5",
		})
		set_hl(0, "FlashMatch", {
			bg = "#5377da",
			fg = "#b6c5f0",
		})
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
