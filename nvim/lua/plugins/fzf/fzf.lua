local custom_key = require("util.keymap")

return {
	"ibhagwan/fzf-lua",
	opts = function(_, opts)
		return {
			fzf_colors = true,
			border = "rounded",
			files = {
				follow = true,
			},
			grep = {
				prompt = vim.g.icons.Telescope.Prefix,
				input_prompt = "Grep For❯ ",
				follow = true,
			},
			winopts = {
				on_create = function()
					-- creates a local buffer mapping translating <M-BS> to <C-u>
					vim.keymap.set("t", custom_key.platform_key.cmd .. "-k>", function()
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-k>", true, false, true), "n", true)
					end, { nowait = true, buffer = true })
					vim.keymap.set("t", custom_key.platform_key.cmd .. "-j>", function()
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
		}
	end,
}
