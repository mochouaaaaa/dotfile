
local M = {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = "ConformInfo",
}

function M.opts()
    local rc = require("plugins.lsp.global.conform")
	local prettier_config = rc.resolve_config("prettierd")

	return {
		formatters = {
			prettier = {
				prepend_args = function()
					return { "--config", prettier_config() }
				end,
			},
		},
		formatters_by_ft = {

			-- JavaScript
			javascript = { "prettierd" },
			["javascript.jsx"] = { "prettierd" },
			typescript = { "prettierd" },
			["typescript.jsx"] = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescriptreact = { "prettierd" },

			-- JSON/XML
			json = { "prettierd" },
			jsonc = { "prettierd" },
			json5 = { "prettierd" },
			yaml = { "prettierd" },
			["yaml.docker-compose"] = { "prettierd" },
			html = { "prettierd" },

			-- Markdown
			markdown = { "prettierd" },
			["markdown.mdx"] = { "prettierd" },

			-- toml
			toml = { "taplo" },
			-- Nix
			nix = { "nixfmt" },

			-- CSS
			css = { "prettierd", "stylelint" },
			less = { "prettierd", "stylelint" },
			scss = { "prettierd", "stylelint" },
			sass = { "prettierd", "stylelint" },

			configuration = { "prettierd" },
			-- Use the "*" filetype to run formatters on all filetypes.
			swift = { "swiftformat" },
		},
	}
end

return M
