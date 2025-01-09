return {
	{
		"chrisgrieser/nvim-lsp-endhints",
		event = "LspAttach",
		config = function()
			require("lsp-endhints").setup({
				icons = {
					type = "󰜁 ",
					parameter = "󰏪 ",
					offspec = " ", -- hint kind not defined in official LSP spec
					unknown = " ", -- hint kind is nil
				},
				label = {
					padding = 1,
					marginLeft = 0,
					bracketedParameters = true,
				},
				autoEnableHints = true,
			})
		end,
	},
	{
		"aznhe21/actions-preview.nvim",
		config = function()
			local hl = require("actions-preview.highlight")
			require("actions-preview").setup({
				diff = {
					algorithm = "patience",
					ignore_whitespace = true,
				},
				highlight_command = {
					hl.delta("delta --no-gitconfig --side-by-side"),
					hl.diff_so_fancy("diff-so-fancy", "less -R"),
				},
				telescope = {
					sorting_strategy = "ascending",
					layout_strategy = "vertical",
					layout_config = {
						width = 0.8,
						height = 0.9,
						prompt_position = "top",
						preview_cutoff = 20,
						preview_height = function(_, _, max_lines)
							return max_lines - 15
						end,
					},
				},
			})
		end,
	},
	{ import = "plugins.lsp.extra" },
}
