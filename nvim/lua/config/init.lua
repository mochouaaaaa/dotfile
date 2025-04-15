if vim.env.VSCODE then
	vim.g.vscode = true
end

vim.g.neovide_enabled = vim.g.neovide

vim.g.IS_NIX = os.getenv("NVIM_IS_NIX")

vim.g.python_lsp = "basedpyright"

require("config.keymaps")
require("config.autocmds")
require("config.options")
require("config.diagnositc")
require("config.filetype")
require("config.shell")
require("config.neovide")
