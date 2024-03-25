local M = {}

function M.on_attach(client, buffer)
	vim.g.syntastic_python_checkers = { "mypy" }

	-- local rc = client.resolver_capabilities()
	--
	-- if client.name == "pyright" then
	-- 	rc.hover = false
	-- end
	--
	-- if client.name == "pylsp" then
	-- 	rc.rename = false
	-- 	rc.signature_help = false
	-- end
end

local util = require("lspconfig.util")

local function organize_imports()
	local params = {
		command = "pyright.organizeimports",
		arguments = { vim.uri_from_bufnr(0) },
	}

	local clients = vim.lsp.get_active_clients {
		bufnr = vim.api.nvim_get_current_buf(),
		name = "pyright",
	}
	for _, client in ipairs(clients) do
		client.request("workspace/executeCommand", params, nil, 0)
	end
end

M.extra = function(config)
	return {
		commands = {
			PyrightOrganizeImports = {
				organize_imports,
				description = "Organize Imports",
			},
		},
		single_file_support = true,
		root_dir = function(fname)
			local root_files = {
				"pyproject.toml",
				"setup.py",
				"setup.cfg",
				"requirements.txt",
				"Pipfile",
				"pyrightconfig.json",
				".python-version",
			}
			local cwd = util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or nil
			local cache_cwd
			if cwd == nil then
				cache_cwd = vim.env.HOME
			else
				cache_cwd = cwd
			end
			cache_cwd = cache_cwd .. "/.cache/venv-selector/"
			require("venv-selector").setup {
				pyenv_path = "/Volumes/Code/tools/.pyenv/versions",
				cache_dir = cache_cwd,
				cache_file = cache_cwd .. "/venvs.json",
				notify_user_on_activate = false,
			}

			require("venv-selector").retrieve_from_cache()

			return cwd
		end,
	}
end

M.capapilities = {
	textDocument = {
		publishDiagnostics = {
			tagSupport = {
				valueSet = {
					2,
				},
			},
		},
	},
}

return M
