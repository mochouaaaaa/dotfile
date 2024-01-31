local M = {
	"windwp/nvim-spectre",
	build = "build build.sh",
	event = "VeryLazy",
	lazy = true,
	config = function()
		require("spectre").setup {
			default = {
				replace = {
					cmd = "oxi",
				},
			},
		}
		local wk = require("which-key")
		wk.register {
			["<leader>s"] = {
				name = "search",
				["r"] = {
					name = "replace",
				},
			},
		}
	end,
}

M.keys = {
	{
		"<leader>srf",
		function() require("spectre").open_file_search { select_word = true } end,
		desc = "Search current file word",
	},
	{
		"<leader>srw",
		function() require("spectre").open_visual { select_word = true } end,
		desc = "Search Word Word",
	},

	{
		"<leader>srv",
		function() require("spectre").open_visual() end,
		mode = "v",
		desc = "replace search visul string",
	},
}

return M
