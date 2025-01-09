return {
	enabled = true,
	has_suggestions = function()
		return require("fittencode").has_suggestions()
	end,
	config = function(utils)
		return {
			"luozhiya/fittencode.nvim",
			config = function()
				local fitten_code = require("fittencode")
				fitten_code.setup({
					use_default_keymaps = false,
					keymaps = {
						inline = {},
					},
					disable_specific_inline_completion = {
						suffixes = { "TelescopePrompt", "neo-tree-popup" },
					},
				})

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
				vim.opt.updatetime = 200
			end,
		}
	end,
}
