if vim.env.VSCODE then
	vim.g.vscode = true
end

vim.g.python_lsp = "basedpyright"

-- copilot proxy
local ok, _ = pcall(require, "copilot")
if ok then
	vim.g.copilot_proxy = false
end
