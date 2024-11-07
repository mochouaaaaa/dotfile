require("config.keymaps")
require("config.autocmds")
require("config.options")
require("config.diagnositc")
require("config.filetype")
require("config.shell")

if vim.env.VSCODE then
    vim.g.vscode = true
end

vim.g.python_lsp = "basedpyright"

-- copilot proxy
local ok, _ = pcall(require, "copilot")
if ok then
    vim.g.copilot_proxy = false
end
