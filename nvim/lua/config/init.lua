require("config.keymaps")
require("config.autocmds")
require("config.options")

if vim.env.VSCODE then
    vim.g.vscode = true
end

vim.g.python_lsp = "basedpyright"
