return {
	"nvim-neotest/neotest",
	require("neotest").setup({
		adapters = {
			["neotest-python"] = {
				dap = { justMyCode = false },
				runner = "pytest",
				-- python = function()
				-- 	local venv_python = vim.fn.getcwd() .. "/.venv/bin/python"
				-- 	if vim.fn.executable(venv_python) == 1 then
				-- 		return venv_python
				-- 	end
				-- 	return "python" -- 回退到系统 python
				-- end,
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
}
