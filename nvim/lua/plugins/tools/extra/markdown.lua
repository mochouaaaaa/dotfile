local M = {
	-- {
	-- 	"iamcco/markdown-preview.nvim",
	-- 	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	-- 	build = "cd app && yarn install",
	-- 	lazy = true,
	-- 	init = function()
	-- 		vim.g.mkdp_filetypes = { "markdown" }
	-- 	end,
	-- 	ft = { "markdown" },
	-- 	config = function()
	-- 		local wk = require("which-key")
	-- 		wk.add({
	-- 			{ "<leader>m", group = "Markdown" },
	-- 			{ "<leader>ms", "<Cmd>MarkdownPreview<CR>", desc = "markdown server start" },
	-- 			{ "<leader>mt", "<Cmd>MarkdownPreviewStop<CR>", desc = "markdown server stop" },
	-- 			{ "<leader>ml", "<Cmd>MarkdownPreviewToggle<CR>", desc = "markdown server toggle" },
	-- 		})
	-- 	end,
	-- },
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
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
		"vhyrro/luarocks.nvim",
		priority = 1001, -- this plugin needs to run before anything else
		opts = {
			-- rocks = { "magick" },
		},
	},
	{
		"3rd/image.nvim",
		build = false,
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
