local M = {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = "ConformInfo",
}

M.configs = {
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
	python = {
		files = {
			"pyproject.toml",
			"ruff.toml",
			".ruff.toml",
		},
		default = vim.fn.expand("$HOME/.config/ruff/pyproject.toml"),
	},
	swiftlint = {
		files = {
			"swiftlint.yml",
		},
		default = vim.fn.expand("$HOME/.config/rules/swiftlint.yml"),
	},
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

function M.opts(_, opts)
	local prettier_config = M.resolve_config("prettierd")

	return vim.tbl_deep_extend("force", opts, {
		formatters = {
			prettier = {
				prepend_args = function()
					return { "--config", prettier_config() }
				end,
			},
			stylua = {
				prepend_args = function()
					return { "--config-path", M.resolve_config("stylua")(), "--no-editorconfig" }
				end,
			},
			ruff_format = {
				prepend_args = function()
					return { "format", "--config", M.resolve_config("python")() }
				end,
			},
			rustfmt = {
				prepend_args = function()
					return { "--config-path", M.resolve_config("rustfmt")() }
				end,
			},
		},
		formatters_by_ft = {
			lua = { "stylua" },
			luau = { "stylua" },

			python = function(bufnr)
				return { "ruff_format" }
			end,
			go = { "goimports", "gofumpt" },
			rust = { "rustfmt" },

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

			-- toml
			toml = { "taplo" },
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
	})
end

return M
