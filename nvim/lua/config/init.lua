if vim.env.VSCODE then
	vim.g.vscode = true
end

vim.g.neovide_enabled = vim.g.neovide

require("config.diagnositc")
require("config.filetype")
require("config.shell")
require("config.neovide")
require("config.lsp")
