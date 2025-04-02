if vim.env.VSCODE then
	vim.g.vscode = true
end

vim.g.IS_NIX = os.getenv("NVIM_IS_NIX")

vim.g.python_lsp = "basedpyright"
