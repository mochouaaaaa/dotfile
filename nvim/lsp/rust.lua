local common = require("util.lsp")

return {
	on_attach = function(client, bufnr)
		common.setup(client, bufnr)
	end,
	capabilities = common.make_capabilities(),
	settings = {
		tools = {
			inlay_hints = {
				auto = false,
			},
		},
		cargo = {
			allFeatures = { allFeatures = true },
			proMacro = { enabled = true },
			checkOnSave = { command = "clippy" },
		},
	},
}
