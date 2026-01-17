local utils = require("util.keymap")

return {
	"nvim-neo-tree/neo-tree.nvim",
	keys = function()
		return {
			{
				utils.platform_key.cmd("e"),
				"<Cmd>Neotree toggle<CR>",
				mode = "n",
			},
			{
				"<leader>eg",
				"<Cmd>Neotree git_status<CR>",
				mode = "n",
				desc = "Toggle git status in neo-tree",
			},
			{
				"<leader>ef",
				"<Cmd>Neotree buffers<CR>",
				mode = "n",
				desc = "Toggle buffers in neo-tree",
			},
		}
	end,
}
