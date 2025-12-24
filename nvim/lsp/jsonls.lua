local common = require("util.lsp")

return {
	on_attach = function(client, bufnr)
		common.setup(client, bufnr)
	end,
	capabilities = common.make_capabilities(),
	init_options = {
		provideFormatter = true,
	},
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = false },
			format = {
				enable = true,
			},
		},
	},
}
