local M = {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			heading = {
				border = true,
				border_virtual = true,
			},
			pipe_table = { preset = "round" },
			code = {
				width = "block",
				right_pad = 4,
				style = "language",
			},
			link = {
				image = "󰋵 ",
				email = " ",
				hyperlink = "󰌷 ",
			},
		},
	},
	{
		"3rd/image.nvim",
		build = true,
		enabled = not vim.g.vscode,
		dependencies = { "luarocks.nvim" },
		opts = {
			backend = "kitty",
			processor = "magick_rock", -- or "magick_cli"
			integrations = {
				markdown = {
					only_render_image_at_cursor = true,
				},
			},
		},
	},
}

return M
