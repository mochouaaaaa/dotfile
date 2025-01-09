local custom_key = require("util.keymap")

return {
	{
		"ibhagwan/fzf-lua",
		opts = function(_, opts)
			-- local actions = require("fzf-lua").actions
			-- actions = {
			-- files = {
			-- ["enter"] = actions.file_switch_or_edit,
			-- },
			-- }
			return {
				grep = {
					prompt = vim.g.icons.Telescope.Prefix,
					input_prompt = "Grep For❯ ",
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
							vim.api.nvim_feedkeys(
								vim.api.nvim_replace_termcodes("<S-up>", true, false, true),
								"i",
								true
							)
						end, { nowait = true, buffer = true })
						vim.keymap.set("t", "<S-j>", function()
							vim.api.nvim_feedkeys(
								vim.api.nvim_replace_termcodes("<S-down>", true, false, true),
								"i",
								true
							)
						end, { nowait = true, buffer = true })
					end,
				},
			}
		end,
		keys = function()
			return {
				{
					custom_key.platform_key.cmd .. "-f>",
					function()
						require("fzf-lua").files(function()
							return { cwd_prompt = false, cwd_header = true, cwd = vim.loop.cwd() }
						end)
					end,
					desc = "Find files",
				},
				{
					custom_key.platform_key.cmd .. "-F>",
					function()
						require("fzf-lua").live_grep({ exec_empty_query = true })
					end,
					desc = "Word (cwd)",
				},
				{ "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
			}
		end,
	},
}
