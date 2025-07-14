return {
	"mfussenegger/nvim-lint",
	lazy = true,

	opts = function(_, opts)
		local rc = require("plugins.lsp.global.conform")

		return vim.tbl_deep_extend("keep", opts, {
			linters_by_ft = {
				lua = { "luacheck" },
			},
			linters = {
				luacheck = {
					args = {
						"--config",
						rc.resolve_config("luacheck"),
						"--formatter",
						"plain",
						"--codes",
						"--ranges",
						"-",
					},
				},
			},
		})
	end,
}
