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
			nil_ls = {
				settings = {
					formatting = {
						command = "nixfmt",
					},
					diagnostics = {
						excludedFiles = {
							"result",
						},
					},
					nix = {
						binary = "nix",
						maxMemoryMB = 2560,

						flake = {
							autoArchive = false,
							autoEvalInputs = false,
							nixpkgsInputName = "nixpkgs",
						},
					},
				},
			},
		},
	},
}
