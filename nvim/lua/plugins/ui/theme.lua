return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		enabled = true,
		config = function()
			require("plugins.ui.theme.mode").setup()
		end,
	},
}
