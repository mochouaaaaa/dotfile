return {
	"mfussenegger/nvim-lint",
	lazy = true,

	opts = function(_, opts)
		local rc = require("plugins.lsp.global.conform")

		return vim.tbl_deep_extend("keep", opts, {
			linters_by_ft = {
				python = { "ruff" },
			},
			linters = {
				ruff = {
					args = {
						"check",
						"--stdin-filepath",
						"$FILENAME",
						"--config",
						rc.resolve_config("python"),
					},
				},
			},
		})
	end,
}
