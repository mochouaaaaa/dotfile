return {
	{
		"aznhe21/actions-preview.nvim",
		config = function()
			local actions_preview = require("actions-preview")
			local hl = require("actions-preview.highlight")

			actions_preview.setup({
				diff = {
					algorithm = "patience",
					ignore_whitespace = true,
					ctxlen = 5,
				},
				highlight_command = {
					hl.delta("delta --no-gitconfig --side-by-side"),
					hl.diff_so_fancy("diff-so-fancy", "less -R"),
					hl.diff_highlight(),
				},
				backend = { "snacks", "nui" },
			})
		end,
	},
	{ import = "plugins.lsp" },
	{ import = "plugins.lsp.code" },
}
