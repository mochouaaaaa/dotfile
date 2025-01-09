local Util = require("lazyvim.util")

local M = {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	dependencies = { "mason.nvim" },
	lazy = true,
	cmd = "ConformInfo",
	configs = {
		stylua = {
			files = { "stylua.toml", ".stylua.toml" },
			default = vim.fn.expand("$HOME/.config/rules/stylua.toml"),
		},
		luacheck = {
			files = { ".luacheckrc" },
			default = vim.fn.expand("$HOME/.config/rules/.luacheckrc"),
		},
		revive = {
			files = { "revive.toml" },
			default = vim.fn.expand("$HOME/.config/rules/revive.toml"),
		},
		rustfmt = {
			files = { "rustfmt.toml", ".rustfmt.toml" },
			default = vim.fn.expand("$HOME/.config/rules/rustfmt.toml"),
		},
		prettier = {
			files = {
				".prettierrc",
				".prettierrc.js",
				".prettierrc.json",
				".prettierrc.yaml",
				".prettierrc.yml",
				"prettier.config.js",
			},
			default = vim.fn.expand("$HOME/.config/rules/.prettierrc.json"),
		},
		stylelint = {
			files = {
				".stylelintrc",
				".stylelintrc.js",
				".stylelintrc.json",
				".stylelintrc.yaml",
				".stylelintrc.yml",
				"stylelint.config.js",
			},
			default = vim.fn.expand("$HOME/.config/rules/stylelint/stylelint.config.js"),
		},
		python = {
			files = {
				"pyproject.toml",
				"ruff.toml",
				".ruff.toml",
			},
			default = vim.fn.expand("$HOME/.config/rules/pyproject.toml"),
		},
		swiftlint = {
			files = {
				"swiftlint.yml",
			},
			default = vim.fn.expand("$HOME/.config/rules/swiftlint.yml"),
		},
	},
	init = function()
		-- Install the conform formatter on VeryLazy
		require("lazyvim.util").on_very_lazy(function()
			require("lazyvim.util").format.register({
				name = "conform.nvim",
				priority = 100,
				primary = true,
				format = function(buf)
					require("conform").format({ bufnr = buf })
				end,
				sources = function(buf)
					local ret = require("conform").list_formatters(buf)
					---@param v conform.FormatterInfo
					return vim.tbl_map(function(v)
						return v.name
					end, ret)
				end,
			})
		end)
	end,
}

function M.resolve_config(type)
	local config = M.configs[type]
	local cache = {}

	local function glob(cwd, dir)
		for _, file in ipairs(config.files) do
			if vim.fn.filereadable(dir .. "/" .. file) == 1 then
				cache[cwd] = dir .. "/" .. file
				return true
			end
		end
	end

	return function()
		local cwd = vim.fn.getcwd()
		if cache[cwd] then
			return cache[cwd]
		end

		if glob(cwd, cwd) then
			return cache[cwd]
		end

		for dir in vim.fs.parents(cwd) do
			if glob(cwd, dir) then
				return cache[cwd]
			end
		end

		cache[cwd] = config.default
		return cache[cwd]
	end
end

function M.opts()
	local stylua_config = M.resolve_config("stylua")
	local rustfmt_config = M.resolve_config("rustfmt")
	local prettier_config = M.resolve_config("prettierd")
	local stylelint_config = M.resolve_config("stylelint")
	local python_config = M.resolve_config("python")

	return {
		formatters = {
			stylua = {
				prepend_args = function()
					return { "--config-path", stylua_config(), "--no-editorconfig" }
				end,
			},
			rustfmt = {
				prepend_args = function()
					return { "--config-path", rustfmt_config() }
				end,
			},
			prettier = {
				prepend_args = function()
					return { "--config", prettier_config() }
				end,
			},
			stylelint = {
				prepend_args = function()
					return { "-c", stylelint_config(), "--stdin-filepath", "$FILENAME" }
				end,
			},
			ruff_format = {
				prepend_args = function()
					return { "format", "--config", python_config() }
				end,
			},
		},
		formatters_by_ft = {
			lua = { "stylua" },
			luau = { "stylua" },

			-- Golang
			go = { "goimports", "gofmt" },

			-- Rust
			rust = { "rustfmt" },

			-- Python
			python = function(bufnr)
				return { "ruff_format" }
			end,

			-- JavaScript
			javascript = { "prettierd" },
			["javascript.jsx"] = { "prettierd" },
			typescript = { "prettierd" },
			["typescript.jsx"] = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescriptreact = { "prettierd" },

			-- JSON/XML
			json = { "prettierd" },
			jsonc = { "prettierd" },
			json5 = { "prettierd" },
			yaml = { "prettierd" },
			["yaml.docker-compose"] = { "prettierd" },
			html = { "prettierd" },

			-- Markdown
			markdown = { "prettierd" },
			["markdown.mdx"] = { "prettierd" },

			-- Nix
			nix = { "nixfmt" },

			-- CSS
			css = { "prettierd", "stylelint" },
			less = { "prettierd", "stylelint" },
			scss = { "prettierd", "stylelint" },
			sass = { "prettierd", "stylelint" },

			configuration = { "prettierd" },
			-- Use the "*" filetype to run formatters on all filetypes.
			swift = { "swiftformat" },
		},
	}
end

return M
