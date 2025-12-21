local custom_key = require("util.keymap")

return {
	"ibhagwan/fzf-lua",
	opts = function(_, opts)
		return {
			fzf_colors = true,
			fzf_opts = {
				["--color"] = "bg:-1",
			},
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
				hl = {
					normal = "NormalFloat", -- 对应 fzf 的 bg
					border = "FloatBorder", -- 对应 fzf 的 border

					cursor = "Cursor",
					-- cursorline = "CursorLine", -- 对应 fzf 的 bg+
					cursorline = "Visual", -- 使用主题的选中高亮组
					cursorlinenbr = "CursorLineNr",

					search = "Search", -- 对应 fzf 的 hl
					preview_normal = "NormalFloat",
					preview_border = "FloatBorder",
				},
				on_create = function()
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
