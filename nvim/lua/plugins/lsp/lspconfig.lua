return {
	"neovim/nvim-lspconfig",
	opts = {
		inlay_hints = {
			enabled = true,
		},
		folds = {
			enabled = false,
		},
		servers = {
			statix = { enabled = false },

			["*"] = {
				keys = {
					-- Disable a keymap
					{ "gd", false },
				},
			},
		},
	},
}
