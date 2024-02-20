local utils = require("config.utils")

return {
	{
		"numToStr/Comment.nvim",
		config = function()
			-- gcc和gc注释修改为D-/
			require("Comment").setup {
				toggler = {
					line = utils.platform_key("cmd") .. "-/>",
				},
				opleader = {
					line = utils.platform_key("cmd") .. "-/>",
				},
			}
		end,
	},
	{
		"folke/todo-comments.nvim",
		config = function()
			require("todo-comments").setup {}
			vim.keymap.set("n", "<leader>ft", "<Cmd>TodoTelescope<CR>", { desc = "project all todo" })
		end,
	},
}
