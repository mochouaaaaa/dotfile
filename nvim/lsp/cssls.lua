local common = require("util.lsp")

return {
	on_attach = function(client, bufnr)
		common.setup(client, bufnr)
	end,
	capabilities = common.make_capabilities(),
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
