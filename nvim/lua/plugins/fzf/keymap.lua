local custom_key = require("util.keymap")

return {
	"ibhagwan/fzf-lua",
	keys = function()
		local fzf_lua = require("fzf-lua")
		return {
			{
				custom_key.platform_key.cmd .. "-f>",
				function()
					fzf_lua.files(function()
						return { cwd_prompt = false, cwd_header = true, hidden = false, cwd = vim.loop.cwd() }
					end)
				end,
				desc = "Find files",
			},
			{
				custom_key.platform_key.cmd .. "-F>",
				function()
					fzf_lua.live_grep({ exec_empty_query = true })
				end,
				desc = "Word (cwd)",
			},
			{ "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
			{
				"<leader>ghl",
				function()
					fzf_lua.fzf_live(
						"git rev-list --all | xargs git grep --line-number --column --color=always <query>",
						{
							fzf_opts = {
								["--delimiter"] = ":",
								["--preview-window"] = "nohidden,down,60%,border-top,+{3}+3/3,~3",
							},
							preview = "git show {1}:{2} | "
								.. "bat --style=default --color=always --file-name={2} --highlight-line={3}",
						}
					)
				end,
			},
		}
	end,
}
