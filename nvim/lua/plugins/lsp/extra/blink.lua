local keymap = require("util.keymap")

local M = {
	"saghen/blink.cmp",
	version = "1.*",
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			config = function()
				require("luasnip.loaders.from_lua").lazy_load({
					paths = vim.fn.stdpath("config") .. "/snippets",
				})
			end,
		},
		{
			"saghen/blink.compat",
		},
	},
	opts = {
		snippets = { preset = "luasnip" },
		appearance = {
			highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
		},
		fuzzy = { implementation = "lua" },
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
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
				["<Tab>"] = { "snippet_forward", "fallback" },
				[keymap.platform_key.cmd("e")] = { "hide", "fallback" },

				[keymap.platform_key.cmd("k")] = { "select_prev", "fallback" },
				[keymap.platform_key.cmd("j")] = { "select_next", "fallback" },
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
				menu = { auto_show = false },
				ghost_text = { enabled = true },
			},
		},
		completion = {
			keyword = { range = "prefix" },
			ghost_text = { enabled = true },
			documentation = {
				auto_show = true,
				window = {
					-- border = rounded,
				},
			},
			menu = {
				-- border = rounded,
				draw = {
					treesitter = { "lsp" },
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
			},
		},
		signature = {
			enabled = true,
			window = {
				border = "rounded",
			},
		},
		keymap = {
			preset = "enter",
			[keymap.platform_key.cmd("k")] = { "select_prev", "fallback" },
			[keymap.platform_key.cmd("j")] = { "select_next", "fallback" },
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
			[keymap.platform_key.cmd("e")] = { "hide", "fallback" },
		},
	},
}

-- local util_dir = vim.fn.stdpath("config") .. "/lua/util/code/"
-- for _, file in ipairs(vim.fn.readdir(util_dir)) do
-- 	if file:match("%.lua$") then
-- 		local module_name = "util.code." .. file:match("(.+)%.lua")
-- 		local ok, module = pcall(require, module_name)
-- 		if ok and module and module.enabled then
-- 			local config_result = module.config and module.config(keymap) or nil
-- 			if config_result then
-- 				table.insert(M.dependencies, config_result)
-- 			end
-- 		end
-- 	end
-- end

return M
