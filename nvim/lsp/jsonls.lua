return {
	init_options = {
		provideFormatter = true,
	},
	settings = {
		json = {
			-- schemas = require("schemastore").json.schemas(),
			validate = { enable = false },
			format = {
				enable = true,
			},
		},
	},
}
