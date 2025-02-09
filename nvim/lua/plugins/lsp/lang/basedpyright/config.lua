local M = {}

local util = require("lspconfig.util")

local root_files = {
	"pyproject.toml",
	"setup.py",
	"setup.cfg",
	"requirements.txt",
	"Pipfile",
	"pyrightconfig.json",
	".python-version",
}

M.extra = function(config)
	return {
		enabled = vim.g.python_lsp == "basedpyright",
		root_dir = function(fname)
			-- local cwd = util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or nil
			local cwd = util.root_pattern(unpack(root_files))(fname)
				or vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
			return cwd
		end,
	}
end

return M
