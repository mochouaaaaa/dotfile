return {
	"zeioth/heirline-components.nvim",
	keys = function()
		local buffer = require("heirline-components.buffer")
		local keymap = require("util.keymap")

		return {
			{
				"<S-h>",
				function()
					buffer.nav(-1)
				end,
				desc = "move right buffer",
			},
			{
				"<S-l>",
				function()
					buffer.nav(1)
				end,
				desc = "move left buffer",
			},
			{
				keymap.platform_key.cmd .. "-w>",
				function()
					buffer.wipe()
				end,
				desc = "Close the current window.",
			},
			{
				"<leader>bDl",
				function()
					buffer.close_right()
				end,
				desc = "Close buffers to the right of the current buffer.",
			},
			{
				"<leader>bDh",
				function()
					buffer.close_left()
				end,
				desc = "Close buffers to the left of the current buffer.",
			},
		}
	end,
}
