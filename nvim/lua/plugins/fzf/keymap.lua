local custom_key = require("util.keymap")

return {
	"ibhagwan/fzf-lua",
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
}
