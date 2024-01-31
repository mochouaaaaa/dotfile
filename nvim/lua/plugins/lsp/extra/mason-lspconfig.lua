local mason_tools = {
	-- Lua
	"lua-language-server", -- language server
	"stylua", -- formatter
	"luacheck", -- linter

	-- Golang
	"gopls", -- language server
	"goimports", -- formatter
	"revive", -- linter

	-- Python
	"pyright",
	"isort",
	"black",
	-- "ruff_format",

	-- Rust
	"rust-analyzer", -- language server

	-- Shell
	"bash-language-server", -- language server
	"shfmt", -- formatting

	-- FE
	"typescript-language-server", -- TypeScript language server
	"css-lsp", -- CSS language server
	"json-lsp", -- JSON language server
	"tailwindcss-language-server", -- Tailwind language server
	-- "prettier", -- formatter
	"prettierd",
	-- "eslint-lsp", -- linter
	"stylelint", -- linter
	"eslint_d",
	"prisma-language-server",

	-- XML
	"html-lsp", -- HTML language server
	"taplo", -- TOML language server
	"yaml-language-server", -- YAML language server
	"lemminx", -- XML language server

	-- Docker
	"dockerfile-language-server",
	"docker-compose-language-service",

	-- GitHub Action
	"actionlint", -- linter

	-- Misc
	"cspell", -- spell checker
	"marksman", -- Markdown language server
	"sqlls", -- SQL language server
}

local M = {
	"williamboman/mason-lspconfig.nvim",
	cmd = "LspInstall",
	dependencies = {
		{
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			opts = { ensure_installed = mason_tools },
		},
	},
}

return M
