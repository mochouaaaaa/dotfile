local keymap = require("util.keymap")

return {
	"snacks.nvim",
	opts = {
		animate = {
			duration = 20,
			fps = 60,
		},
		image = {
			enabled = true,
		},
		picker = {
			ui_select = true,
			win = {
				input = {
					keys = {
						["<Esc>"] = { "close", mode = { "n", "i" } },
						[keymap.platform_key.cmd("j")] = { "list_down", mode = { "i", "n" } },
						[keymap.platform_key.cmd("k")] = { "list_up", mode = { "i", "n" } },
						[keymap.platform_key.cmd("J")] = { "preview_scroll_down", mode = { "i", "n" } },
						[keymap.platform_key.cmd("K")] = { "preview_scroll_up", mode = { "i", "n" } },
					},
				},
			},
		},
		lazygit = {
			win = {
				border = "rounded",
			},
		},
	},
	keys = {
		{
			keymap.platform_key.cmd("e"),
			function()
				Snacks.picker.explorer()
			end,
			mode = "n",
		},
		{
			keymap.platform_key.cmd("f"),
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			keymap.platform_key.cmd("F"),
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
	},
}
