local HEADER = "`<alt-i>` use .gitignore"
local custom_key = require("util.keymap")

return {
	"ibhagwan/fzf-lua",
	opts = {
		files = {
			header = HEADER,
			prompt = vim.g.icons.Telescope.Prefix,
			git_icons = true,
			path_shorten = 6,
			cwd = vim.fn.exepath("%:p:h"),
			cwd_prompt = true,
			cwd_header = false,
			hidden = false,
		},
		grep = {
			header = false,
			prompt = vim.g.icons.Telescope.Prefix,
			input_prompt = "Grep For❯ ",
			git_icons = true,
			rg_glob = true,
		},
	},
	keys = function()
		local fzf_lua = require("fzf-lua")
		return {
			{
				custom_key.platform_key.cmd("f"),
				function()
					fzf_lua.files(function()
						return { cwd_prompt = false, cwd_header = true, hidden = false, cwd = vim.loop.cwd() }
					end)
				end,
				{ silent = true, desc = "Find files" },
			},
			{
				custom_key.platform_key.cmd("F"),
				function()
					fzf_lua.live_grep({ exec_empty_query = true })
				end,
				{ silent = true, desc = "Word (cwd)" },
			},
			{ "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
		}
	end,
}
