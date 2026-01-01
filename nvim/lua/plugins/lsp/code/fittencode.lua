return {
	{
		"saghen/blink.cmp",
		opts = {
			sources = {
				completion = {
					enabled_providers = { "lsp", "path", "snippets", "buffer", "fittencode" },
				},
				-- set custom providers with fittencode
				providers = {
					fittencode = {
						name = "fittencode",
						module = "fittencode.sources.blink",
					},
				},
			},
		},
	},
	{
		"luozhiya/fittencode.nvim",
		enabled = vim.g.CODE.fittencode,
		event = "InsertEnter",
		opts = {
			chat = {
				highlight_conversation_at_cursor = true,
			},
			use_default_keymaps = false,
			keymaps = {
				inline = {},
			},
			disable_specific_inline_completion = {
				suffixes = { "TelescopePrompt", "neo-tree-popup" },
			},
		},
		config = function(_, opts)
			local utils = require("util.keymap")

			local fitten_code = require("fittencode")
			fitten_code.setup(opts)

			vim.keymap.set("i", "<Tab>", function()
				if fitten_code.has_suggestions() then
					fitten_code.accept_line()
				else
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
				end
			end, { silent = true, desc = "fittencode accept" })

			vim.keymap.set("i", utils.platform_key.cmd .. "-e>", function()
				if fitten_code.has_suggestions() then
					fitten_code.dismiss_suggestions()
				else
					vim.api.nvim_feedkeys(
						vim.api.nvim_replace_termcodes(utils.platform_key.cmd .. "-e>", true, false, true),
						"n",
						false
					)
				end
			end)
		end,
		keys = {
			{
				mode = "v",
				"<leader>af",
				"<CMD>Fitten translate_text<CR>",
				desc = "Translate text",
			},
			{
				"<leader>at",
				"<CMD>Fitten toggle_chat<CR>",
				desc = "Toggle chat",
			},
		},
	},
}
