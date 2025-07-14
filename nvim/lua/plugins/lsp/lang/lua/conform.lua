local M = {
	"stevearc/conform.nvim",
}

M.opts = function(_, opts)
	local rc = require("plugins.lsp.global.conform")
	local stylua_config = rc.resolve_config("stylua")

	return vim.tbl_deep_extend("keep", opts, {

		formatters = {
			stylua = {
				prepend_args = function()
					return { "--config-path", stylua_config(), "--no-editorconfig" }
				end,
			},
		},

		formatters_by_ft = {
			lua = { "stylua" },
			luau = { "stylua" },
		},
	})
end

return M
