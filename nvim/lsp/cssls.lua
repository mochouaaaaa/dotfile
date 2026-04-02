return {
	filetypes = { "css", "scss", "less", "typescriptreact", "javascriptreact" },
	settings = {
		css = {
			validate = true,
			lint = {
				unknownAtRules = "ignore", -- 这里是关键：设置为 "ignore"
			},
		},
		scss = {
			validate = true,
			lint = {
				unknownAtRules = "ignore",
			},
		},
		less = {
			validate = true,
			lint = {
				unknownAtRules = "ignore",
			},
		},
	},
}
