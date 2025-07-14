local M = {
	"stevearc/conform.nvim",
}

M.rustfmt_config = function()
	local rc = require("plugins.lsp.global.conform")
	return rc.resolve_config("rustfmt")
end

M.opts = {
	formatters = {
		rustfmt = {
			prepend_args = function()
				return { "--config-path", M.rustfmt_config() }
			end,
		},
	},
	formatters_by_ft = {
		rust = { "rustfmt" },
	},
}

return M
