return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	lazy = false,
	enabled = true,
	config = function()
		require("plugins.ui.theme.mode").setup()
		vim.cmd.colorscheme("catppuccin")
	end,
}
