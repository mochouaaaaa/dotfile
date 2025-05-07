return {
	{
		"folke/noice.nvim",
		opts = {
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = true, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
		},
		keys = function()
			return {
				{
					"<leader>fn",
					"<CMD>:Noice fzf<CR>",
					desc = "Notification History",
				},
			}
		end,
	},
}
