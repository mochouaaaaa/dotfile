local M = {}

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

return M
