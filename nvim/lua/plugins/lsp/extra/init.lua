return {
	-- 将没有使用到的变量进行暗淡处理。
	{
		"zbirenbaum/neodim",
		lazy = true,
		event = "LspAttach",
		config = function()
			require("neodim").setup {
				alpha = 0.75,
				blend_color = "#10171F",
				update_in_insert = {
					enable = true,
					delay = 100,
				},
				hide = {
					virtual_text = true,
					signs = false,
					underline = false,
				},
			}
		end,
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = "LspAttach",
		cmd = { "TroubleToggle", "Trouble", "TroubleRefresh" },
		opts = {},
		config = function(_, opts)
			require("trouble").setup(opts)
		end,
		keys = {
			{
				"<leader>xc",
				function() require("trouble").close() end,
				mode = { "n" },
				desc = "close diagnostics",
			},
			{
				"<leader>xw",
				function() require("trouble").toggle("workspace_diagnostics") end,
				mode = { "n" },
				desc = "workspace diagnostics",
			},
			{
				"<leader>xf",
				function() require("trouble").toggle("document_diagnostics") end,
				mode = { "n" },
				desc = "this file diagnostics",
			},
			{
				"<leader>xg",
				"<CMD>Gitsigns setqflist<CR>",
				mode = { "n" },
				desc = "this file git change",
			},
		},
	},
}
