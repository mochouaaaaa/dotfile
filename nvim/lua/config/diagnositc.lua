-- Diagnostic
vim.opt.updatetime = 300

vim.fn.sign_define("DiagnosticSignError", { text = vim.g.icons.Diagnostic.Error, texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = vim.g.icons.Diagnostic.Warning, texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = vim.g.icons.Diagnostic.Info, texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = vim.g.icons.Diagnostic.Hint, texthl = "DiagnosticSignHint" })

vim.diagnostic.config({
	virtual_text = {
		-- 显示诊断信息在代码旁
		prefix = "●", -- 可以根据需要自定义前缀
		source = true, -- 显示诊断的来源
		spacing = 4, -- 虚拟文本与代码的距离
		severity = {
			min = vim.diagnostic.severity.WARN, -- 只显示警告及以上的诊断
		},
	},
	float = { header = "", prefix = "", focusable = false, border = "rounded", source = true },
	signs = true, -- 启用符号显示
	underline = true, -- 启用下划线显示
	update_in_insert = false,
	severity_sort = true,
})

-- kitty terminal background
vim.cmd([[highlight Normal guibg=none]])
vim.cmd([[highlight NonText guibg=none]])
vim.cmd([[highlight Normal ctermbg=none]])
vim.cmd([[highlight NonText ctermbg=none]])
