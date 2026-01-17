local keymap = require("util.keymap")

return {
	"ibhagwan/fzf-lua",
	opts = {
		winopts = {
			-- preview = { default = "bat_native", title = false },
			on_create = function()
				vim.keymap.set("t", keymap.platform_key.cmd("k"), function()
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-k>", true, false, true), "n", true)
				end, { nowait = true, buffer = true })

				vim.keymap.set("t", keymap.platform_key.cmd("j"), function()
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-j>", true, false, true), "n", true)
				end, { nowait = true, buffer = true })

				vim.keymap.set("t", "<S-k>", function()
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-up>", true, false, true), "i", true)
				end, { nowait = true, buffer = true })

				vim.keymap.set("t", "<S-j>", function()
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-down>", true, false, true), "i", true)
				end, { nowait = true, buffer = true })
			end,
		},
	},
}
