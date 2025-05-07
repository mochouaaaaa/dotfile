return {
	["nil"] = {
		testSetting = 42,
		filetypes = { "nix" },
		rootPatterns = { "flake.nix", ".git" },
		formatting = {
			command = { "nixfmt" },
		},
	},
}
