return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/neotest-python",
		"fredrikaverpil/neotest-golang",
	},
	opts = function(_, opts)
		opts.adapters = opts.adapters or {}
		vim.list_extend(opts.adapters, {
			require("neotest-python")({
				dap = { justMyCode = false },
				runner = "pytest",
				args = { "--log-level", "DEBUG" },
			}),
			require("neotest-golang")({
				experimental = {
					test_table = true,
				},
				args = { "-v", "-race" },
			}),
		})
		return opts
	end,
}
