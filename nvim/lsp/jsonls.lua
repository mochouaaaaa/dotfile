local common = require("util.lsp")

return {
	on_attach = function(client, bufnr)
		common.setup(client, bufnr)
	end,
	capabilities = common.make_capabilities(),
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
			format = {
				enable = true,
			},
		},
	},
}
