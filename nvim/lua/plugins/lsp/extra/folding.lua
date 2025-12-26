-- Fold 基础设置（适配 ufo + treesitter）
vim.o.foldcolumn = "0"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- 简化 fillchars（foldcolumn=0 时无需 open/close）
vim.o.fillchars = "eob: ,fold: "

-- 高性能 foldtext（不逐字符、不查 TS capture）
function _G.fast_foldtext()
	-- 折叠起始行文本
	local line = vim.fn.getline(vim.v.foldstart)
	line = line:gsub("\t", string.rep(" ", vim.o.tabstop))

	-- 折叠行数
	local nlines = vim.v.foldend - vim.v.foldstart + 1

	return {
		{ line, "Normal" },
		{ ("  …  %d lines"):format(nlines), "Comment" },
	}
end

-- 绑定 foldtext
vim.opt.foldtext = "v:lua.fast_foldtext"

return {}
