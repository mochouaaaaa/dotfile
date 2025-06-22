local lsp = {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	enabled = not vim.g.IS_NIX,
}

local common = require("plugins.lsp.lang.common")
local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

function lsp._sourcekit_lsp()
	return {
		capabilities = common.make_capabilities({
			workspace = { didChangeWatchedFiles = { dynamicRegistration = true } },
		}),
		on_attach = common.setup,
		filetypes = { "swift", "c", "cpp", "objective-c", "objc", "objective-cpp" },
		get_language_id = function(_, ftype)
			return ftype == "objc" and "objective-c" or ftype
		end,
		root_dir = function(filename)
			return util.root_pattern("buildServer.json")(filename)
				or util.root_pattern("*.xcodeproj", "*.xcworkspace")(filename)
				or util.root_pattern("Package.swift")(filename)
				or vim.fn.getcwd()
		end,
	}
end

function lsp.config(_, opts)
	lspconfig.sourcekit.setup(lsp._sourcekit_lsp())

	require("mason-lspconfig").setup_handlers({
		function(server_name)
			local server_module = "plugins.lsp.lang." .. server_name
			local has_config, server_config = pcall(require, server_module .. ".config")
			local has_settings, settings = pcall(require, server_module .. ".settings")

			local capabilities = common.make_capabilities(has_config and server_config.capabilities or {})
			local on_attach = function(client, bufnr)
				common.setup(client, bufnr)
				if has_config and server_config.on_attach then
					server_config.on_attach(client, bufnr)
				end
			end

			local config = { capabilities = capabilities, on_attach = on_attach }
			if has_config and server_config.extra then
				config = vim.tbl_extend("force", config, server_config.extra(config))
			end
			if has_settings then
				config.settings = settings
			end

			lspconfig[server_name].setup(config)
		end,
	})
end

local typescript_ls = {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	opts = function()
		local api = require("typescript-tools.api")
		return {
			on_attach = common.setup,
			handlers = {
				["textDocument/publishDiagnostics"] = api.filter_diagnostics(
					-- Ignore 'This may be converted to an async function' diagnostics.
					{ 80006, 7044 }
				),
			},

			settings = {
				separate_diagnostic_server = true,
				publish_diagnostic_on = "insert_leave",
				tsserver = {
					diagnosticOptions = {
						semantic = false, -- 关闭语义诊断
						suggestion = true, -- 可以打开建议
						syntactic = true, -- 保留语法检查
					},
				},
				tsserver_plugins = {
					"@styled/typescript-styled-plugin",
				},
			},
		}
	end,
}

return {
	lsp,
	typescript_ls,
}
