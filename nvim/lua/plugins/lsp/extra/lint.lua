local M = {
	"mfussenegger/nvim-lint",
	lazy = true,
}

M.opts = {
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
}

function M.config(_, opts)
	local rc = require("plugins.lsp.extra.format")

	local lint = require("lint")

	lint.linters.luacheck.args = {
		"--config",
		rc.resolve_config("luacheck"),
		"--formatter",
		"plain",
		"--codes",
		"--ranges",
		"-",
	}
	lint.linters.revive.args = { "--config", rc.resolve_config("revive") }
	lint.linters.ruff.args = {
		"check",
		"--stdin-filepath",
		"$FILENAME",
		"--config",
		rc.resolve_config("python"),
	}

	lint.linters.stylelint.args = {
		"-c",
		rc.resolve_config("stylelint"),
		"-f",
		"json",
		"--stdin",
		"--stdin-filename",
		function()
			return vim.fn.expand("%:p")
		end,
	}

	lint.linters.swiftlint = {
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
	}

	lint.linters_by_ft = opts.linters_by_ft

	function M.debounce(ms, fn)
		local timer = vim.loop.new_timer()
		return function(...)
			local argv = { ... }
			timer:start(ms, 0, function()
				timer:stop()
				vim.schedule_wrap(fn)(unpack(argv))
			end)
		end
	end

	function M.lint()
		-- Use nvim-lint's logic first:
		-- * checks if linters exist for the full filetype first
		-- * otherwise will split filetype by "." and add all those linters
		-- * this differs from conform.nvim which only uses the first filetype that has a formatter
		local names = lint._resolve_linter_by_ft(vim.bo.filetype)

		-- Add fallback linters.
		if #names == 0 then
			vim.list_extend(names, lint.linters_by_ft["_"] or {})
		end

		-- Add global linters.
		vim.list_extend(names, lint.linters_by_ft["*"] or {})

		local Util = require("lazyvim.util")
		-- Filter out linters that don't exist or don't match the condition.
		local ctx = { filename = vim.api.nvim_buf_get_name(0) }
		ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
		names = vim.tbl_filter(function(name)
			local linter = lint.linters[name]
			if not linter then
				Util.warn("Linter not found: " .. name, { title = "nvim-lint" })
			end
			return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
		end, names)

		-- Run linters.
		if #names > 0 then
			lint.try_lint(names)
		end
	end

	vim.api.nvim_create_autocmd(opts.events, {
		group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
		callback = M.debounce(100, M.lint),
	})

	-- vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
	-- 	group = vim.api.nvim_create_augroup("Linting", { clear = true }),
	-- 	callback = function() lint.try_lint() end,
	-- })
end

return M
