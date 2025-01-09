local M = {
	"neovim/nvim-lspconfig", -- official lspconfig
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
}

local common = require("plugins.lsp.lang.common")

function M._sourcekit_lsp()
	return {
		capabilities = common.make_capabilities({
			workspace = {
				didChangeWatchedFiles = {
					dynamicRegistration = true,
				},
			},
		}),
		on_attach = common.setup,
		filetypes = { "swift", "c", "cpp", "objective-c", "objc", "objective-cpp" },
		get_language_id = function(_, ftype)
			if ftype == "objc" then
				return "objective-c"
			end
			return ftype
		end,
		root_dir = function(filename, _)
			local util = require("lspconfig.util")
			return util.root_pattern("buildServer.json")(filename)
				or util.root_pattern("*.xcodeproj", "*.xcworkspace")(filename)
				-- or util.find_git_ancestor(filename)
				-- or vim.fs.dirname(vim.fs.find(".git", { path = filename, upward = true }))
				or util.root_pattern("Package.swift")(filename)
				or vim.fn.getcwd()
		end,
	}
end

function M.config(_, opts)
	local lspconfig = require("lspconfig")
	lspconfig.sourcekit.setup(M._sourcekit_lsp())
	require("mason-lspconfig").setup_handlers({
		function(server_name)
			local capabilities

			local lsp_server = "plugins.lsp.lang." .. server_name
			-- lsp custom config
			local server_config = lsp_server .. ".config"

			local server_config_attach, server_config_extra
			if pcall(require, server_config) then
				server_config_attach = require(server_config).on_attach
				server_config_extra = require(server_config).extra

				capabilities = common.make_capabilities(require(server_config).capabilities)
			else
				capabilities = common.make_capabilities()
			end

			-- lsp config
			local settings = lsp_server .. ".settings"

			local config = {
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					common.setup(client, bufnr)

					if server_config_attach ~= nil then
						server_config_attach(client, bufnr)
					end
				end,
			}

			-- add extra params
			if server_config_extra ~= nil and type(server_config_extra) == "function" then
				config = vim.tbl_extend("force", config, server_config_extra(config))
			end

			if pcall(require, settings) then
				config.settings = require(settings)
			end

			lspconfig[server_name].setup(config)
		end,
	})
end
return M
