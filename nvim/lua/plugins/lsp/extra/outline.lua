local outline = {
	"hedyhli/outline.nvim",
	lazy = true,
	cmd = { "Outline", "OutlineOpen" },
	opts = {
		-- Your setup opts here
		symbols = {
			filter = {
				default = {
					"String",
					"Variable",
					exclude = true,
				},
				python = { "Function", "Class", "Method" },
			},
		},
	},
}

function outline.config(_, opts) require("outline").setup(opts) end

outline.keys = {
	{
		"<leader>dg",
		"<cmd>Outline<CR>",
		mode = { "n" },
		desc = "大纲",
	},
	{
		"go",
		"<cmd>OutlineFollow<CR>",
		mode = { "n" },
		desc = "jump to outline",
	},
}

return {
	outline,
}
