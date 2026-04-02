local M = {
	"mfussenegger/nvim-lint",
}

M.opts = function(_, opts)
	local rc = require("plugins.lsp.conform")

	return vim.tbl_deep_extend("force", opts, {
		-- Event to trigger linters
		events = { "BufWritePost", "BufReadPost", "InsertLeave" },
		linters_by_ft = {
			lua = { "luacheck" },
			css = { "stylelint" },
			less = { "stylelint" },
			scss = { "stylelint" },
			sass = { "stylelint" },
			yaml = { "actionlint" },

			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },

			-- python = { "ruff" },
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
			-- ruff = {
			-- 	args = {
			-- 		"check",
			-- 		"--stdin-filepath",
			-- 		"$FILENAME",
			-- 		"--config",
			-- 		rc.resolve_config("python"),
			-- 	},
			-- },
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
	})
end

return M
