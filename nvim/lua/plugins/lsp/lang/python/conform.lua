local M = {
	"stevearc/conform.nvim",
	optional = true,
}

M.opts = {
	formatters = {
		ruff_format = {
			prepend_args = function()
				return { "format", "--config", M.python_config() }
			end,
		},
	},
	formatters_by_ft = {
		python = function(bufnr)
			return { "ruff_format" }
		end,
	},
}

M.python_config = function()
	local rc = require("plugins.lsp.global.conform")
	return rc.resolve_config("python")
end

return M
