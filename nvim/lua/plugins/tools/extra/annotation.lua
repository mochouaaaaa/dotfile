return {
	{
		"numToStr/Comment.nvim",
		config = function()
			-- gcc和gc注释修改为D-/
			require("Comment").setup {
				toggler = {
					line = "<D-/>",
				},
				opleader = {
					line = "<D-/>",
				},
			}
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("todo-comments").setup {}
			vim.keymap.set(
				"n",
				"<leader>fd",
				"<Cmd>TodoTelescope<CR>",
				{ desc = "Search through all project todos with Telescope" }
			)
		end,
	},
}
