return {
	"navarasu/onedark.nvim",
	config = function()
		-- Lua
		require("onedark").setup({
			style = "dark",
			-- Lualine options --
			lualine = {
				transparent = not vim.g.neovide, -- lualine center bar transparency
			},

			-- Custom Highlights --
			colors = require("plugins.ui.theme.override"), -- Override default colors
			highlights = {}, -- Override highlight groups
		})
		require("onedark").load()
	end,
}
