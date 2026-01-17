return {
	{
		"zbirenbaum/copilot.lua",
		build = ":Copilot auth",
		cmd = "Copilot",
		event = { "InsertEnter", "LspAttach" },
		enabled = vim.g.CODE.copilot,
		config = function()
			local utils = require("util.keymap")

			vim.g.copilot_proxy = false
			require("copilot").setup({
				panel = {
					enabled = false,
					auto_refresh = false,
					keymap = {
						jump_prev = "[[",
						jump_next = "]]",
						accept = "<Tab>",
						refresh = "gr",
						open = "<M-CR>",
					},
					layout = {
						position = "right",
						ratio = 0.4,
					},
				},
				filetypes = {
					yaml = false,
					markdown = false,
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					plaintext = false,
					scminput = false,
				},
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
					keymap = {
						accept = false,
						next = utils.platform_key.cmd("j"),
						prev = utils.platform_key.cmd("k"),
						dismiss = false,
					},
				},
				server_opts_overrides = {
					-- root_dir = require("lspconfig.util")
				},
			})

			local copilot_suggestion = require("copilot.suggestion")

			vim.keymap.set("i", "<Tab>", function()
				if copilot_suggestion.is_visible() then
					copilot_suggestion.accept()
				else
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
					-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", true)
				end
			end, { silent = true, desc = "copilot accept" })
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		event = { "InsertEnter", "LspAttach" },
		fix_pairs = true,
		enabled = vim.g.CODE.copilot,
		config = function()
			require("copilot_cmp").setup()
		end,
	},
}
