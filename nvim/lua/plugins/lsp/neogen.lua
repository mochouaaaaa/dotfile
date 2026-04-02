return {
	"danymat/neogen",
	cmd = "Neogen",
	opts = {
		input_after_comment = true,

		languages = {
			python = { template = { annotation_convention = "numpydoc" } },
			lua = { template = { annotation_convention = "ldoc" } },
		},
	},

	keys = {
		{
			"<leader>nc",
			"<cmd>Neogen class<CR>",
			desc = "Neogen: class docstring",
		},
		{
			"<leader>nf",
			"<cmd>Neogen func<CR>",
			desc = "Neogen: function docstring",
		},
		{
			"<leader>nn",
			"<cmd>Neogen<CR>",
			desc = "Neogen: generate (auto)",
		},
	},
}
