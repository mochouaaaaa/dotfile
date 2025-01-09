return {
	-- 将没有使用到的变量进行暗淡处理。
	{
		"zbirenbaum/neodim",
		lazy = true,
		event = "LspAttach",
		opts = {
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
		},
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = "LspAttach",
		cmd = { "TroubleToggle", "Trouble", "TroubleRefresh" },
		opts = {
			max_items = 500, -- limit number of items that can be displayed per section
			warn_no_results = false, -- show a warning when there are no results
			open_no_results = true, -- open the trouble window when there are no results
			modes = {
				lsp_references = {
					desc = "LSP References",
					mode = "lsp_references",
					title = false,
					restore = true,
					focus = false,
					follow = false,
				},
				lsp_definitions = {
					desc = "LSP definitions",
					mode = "lsp_definitions",
					title = false,
					restore = true,
					focus = false,
					follow = false,
				},
				lsp_document_symbols = {
					title = false,
					focus = false,
					format = "{kind_icon}{symbol.name} {text:Comment} {pos}",
				},
			},
			keys = {
				q = "close",
			},
		},
		keys = {

			{
				"<leader>xs",
				"<CMD>Trouble symbols toggle focus=false<CR>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>xl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xx",
				"<CMD>Trouble diagnostics toggle<CR>",
				mode = { "n" },
				desc = "this file diagnostics",
			},
		},
	},
}
