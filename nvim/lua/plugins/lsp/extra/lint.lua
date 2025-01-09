local M = {
	"mfussenegger/nvim-lint",
	lazy = true,
}

M.opts = function(_, opts)
	local rc = require("plugins.lsp.extra.conform")

	return {
		-- Event to trigger linters
		events = { "BufWritePost", "BufReadPost", "InsertLeave" },
		linters_by_ft = {
			lua = { "luacheck" },
			python = { "ruff" },
			go = { "revive" },
			css = { "stylelint" },
			less = { "stylelint" },
			scss = { "stylelint" },
			sass = { "stylelint" },
			yaml = { "actionlint" },

			markdown = { "cspell" },
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },

			swift = { "swiftlint" },
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
			revive = {
				args = { "--config", rc.resolve_config("revive") },
			},
			ruff = {
				args = {
					"check",
					"--stdin-filepath",
					"$FILENAME",
					"--config",
					rc.resolve_config("python"),
				},
			},
			stylelint = {
				args = {
					"-c",
					rc.resolve_config("stylelint"),
					"-f",
					"json",
					"--stdin",
					"--stdin-filename",
					function()
						return vim.fn.expand("%:p")
					end,
				},
			},
			swiftlint = {
				args = {
					cmd = "swiftlint",
					stdin = true,
					args = {
						"lint",
						"--use-script-path",
						"--config",
						rc.resolve_config("swiftlint"),
						"-",
					},
					stream = "stdout",
					ignore_exitcode = true,
					parser = require("lint.parser").from_pattern(
						"[^:]+:(%d+):(%d+): (%w+): (.+)",
						{ "lnum", "col", "severity", "message" },
						{
							["error"] = vim.diagnostic.severity.ERROR,
							["warning"] = vim.diagnostic.severity.WARN,
						},
						{ ["source"] = "swiftlint" }
					),
				},
			},
		},
	}
end

return M
