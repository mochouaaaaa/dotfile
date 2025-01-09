local custom_key = require("util.keymap")

local M = {
	"saghen/blink.cmp",
	dependencies = {},
	opts = {
		-- integrations = { blink_cmp = true },
		appearance = {
			highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
		},
		completion = {
			-- 'prefix' will fuzzy match on the text before the cursor
			-- 'full' will fuzzy match on the text before *and* after the cursor
			-- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
			keyword = { range = "prefix" },
			ghost_text = { enabled = true },

			menu = {
				border = vim.g.border.style,
			},
			documentation = {
				window = {
					border = vim.g.border.style,
				},
			},
		},
		signature = {
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
	},
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

return M
