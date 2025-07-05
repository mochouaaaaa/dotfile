local custom_key = require("util.keymap")

local M = {
	"saghen/blink.cmp",
	dependencies = {
		{
			"xzbdmw/colorful-menu.nvim",
			opts = {},
		},
		{ "L3MON4D3/LuaSnip", version = "v2.*", config = function() end },
	},
	opts = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "BlinkCmpMenuOpen",
			callback = function()
				vim.diagnostic.enable(false)
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "BlinkCmpMenuClose",
			callback = function()
				vim.diagnostic.enable(true)
			end,
		})

		return {
			snippets = { preset = "luasnip" },
			appearance = {
				highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
			},
			sources = {
				default = { "lsp", "buffer", "snippets", "path" },
				providers = {
					cmdline = {
						min_keyword_length = function(ctx)
							if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
								return 3
							end
							return 0
						end,
					},
				},
			},
			cmdline = {
				enabled = true,
				keymap = {
					preset = "none",
					-- FIX: 会导致loading
					-- ["<Tab>"] = { "show", "fallback" },
					[custom_key.platform_key.cmd .. "-e>"] = { "hide", "fallback" },

					[custom_key.platform_key.cmd .. "-k>"] = { "select_prev", "fallback" },
					[custom_key.platform_key.cmd .. "-j>"] = { "select_next", "fallback" },
				},
				sources = function()
					local type = vim.fn.getcmdtype()
					-- Search forward and backward
					if type == "/" or type == "?" then
						return { "buffer" }
					end
					-- Commands
					if type == ":" or type == "@" then
						return { "cmdline" }
					end
					return {}
				end,
				completion = {
					menu = {
						auto_show = function(ctx)
							return vim.fn.getcmdtype() == ":"
							-- enable for inputs as well, with:
							-- or vim.fn.getcmdtype() == '@'
						end,
					},
					ghost_text = { enabled = true },
				},
			},
			completion = {
				keyword = { range = "prefix" },
				ghost_text = { enabled = true },
				documentation = {
					auto_show = true,
					window = {
						border = vim.g.border.style,
					},
				},
				menu = {
					border = vim.g.border.style,
					draw = {
						columns = {
							{
								"kind_icon",
							},
							{
								"label",
								gap = 1,
							},
							{
								"source_name",
							},
						},
					},
					components = {
						label = {
							text = function(ctx)
								return require("colorful-menu").blink_components_text(ctx)
							end,
							highlight = function(ctx)
								return require("colorful-menu").blink_components_highlight(ctx)
							end,
						},
					},
				},
			},
			signature = {
				enabled = true,
				window = {
					border = vim.g.border.style,
				},
			},
			keymap = {
				preset = nil,
				[custom_key.platform_key.cmd .. "-k>"] = { "select_prev", "fallback" },
				[custom_key.platform_key.cmd .. "-j>"] = { "select_next", "fallback" },
				["<Tab>"] = {
					function(cmp)
						if cmp.snippet_active() then
							return cmp.accept()
						else
							return cmp.select_and_accept()
						end
					end,
					"snippet_forward",
					"fallback",
				},
				["<C-e>"] = { nil },
				[custom_key.platform_key.cmd .. "-e>"] = { "hide", "fallback" },
			},
		}
	end,
}

local util_dir = vim.fn.stdpath("config") .. "/lua/util/code/"
for _, file in ipairs(vim.fn.readdir(util_dir)) do
	if file:match("%.lua$") then
		local module_name = "util.code." .. file:match("(.+)%.lua")
		local ok, module = pcall(require, module_name)
		if ok and module and module.enabled then
			local config_result = module.config and module.config(custom_key) or nil
			if config_result then
				table.insert(M.dependencies, config_result)
			end
		end
	end
end

local result = {
	{
		"saghen/blink.nvim",
		-- build = "cargo build --release",
		lazy = false,
		opts = {
			chartoggle = { enabled = true },
			-- indent = { enabled = true },
			paris = { enabled = true },
			select = { enabled = true },
			tree = { enabled = false },
		},
	},
	M,
}
return result
