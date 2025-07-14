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
	-- float = {
	-- 	show_header = true,
	-- 	source = "if_many",
	-- 	focusable = true,
	-- 	border = "rounded",
	-- 	severity_sort = true,
	-- },
	signs = true, -- 启用符号显示
	underline = true, -- 启用下划线显示
	update_in_insert = false,
	severity_sort = true,
})
