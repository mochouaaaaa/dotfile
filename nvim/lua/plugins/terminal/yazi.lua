local _key = require("util.keymap")

local M = {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	opts = function(_, opts)
		local config = {
			highlight_hovered_buffers_in_same_directory = false,
			keymaps = {
				show_help = "?",
			},
		}
		return vim.tbl_deep_extend("force", opts, config)
	end,
	keys = {
		{
			_key.platform_key.cmd("r"),
			mode = { "n", "v" },
			"<cmd>Yazi<cr>",
			desc = "Open yazi at the current file",
		},
	},
}

return M
