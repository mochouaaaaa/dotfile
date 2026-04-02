return {
	"nvim-neotest/neotest",
	config = {
		require("neotest").setup({
			adapters = {
				["neotest-python"] = {
					dap = { justMyCode = false },
					runner = "pytest",
					args = { "--log-level", "DEBUG" },
				},
				["neotest-golang"] = {
					experimental = {
						test_table = true, -- 开启后可以单独运行表格驱动测试中的子项
					},
					args = { "-v", "-race" },
				},
			},
		}),
	},
}
