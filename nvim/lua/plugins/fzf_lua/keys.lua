local M = {}

local extr_args = require("plugins.configs.fzf").extr_args

M.keys = {
	{
		"<leader>fh",
		"<Cmd>FzfLua help_tags<CR>",
		desc = " Check out all tags",
	},
	{
		"<leader>fg",
		"<Cmd>FzfLua git_files<CR>",
		desc = "[]Search Git File",
	},
	{
		"<D-S-f>",
		"<Cmd>FzfLua live_grep_native<CR>",
		desc = "Grep (root dir)",
	},
	{
		"<D-f>",
		function()
			require("fzf-lua").files {
				cmd = "rg --color=never --smart-case --files " .. table.concat(extr_args, " "),
			}
		end,
		desc = ".* Search files cucurrent directory",
	},
	{
		"<leader>fb",
		"<Cmd>FzfLua buffers<CR>",
		desc = "find buffers",
	},
	{
		"<C-p>",
		"<cmd>FzfLua commands<cr>",
		desc = "查询所有的command命令",
	},
	{
		"<leader>fk",
		"<Cmd>FzfLua keymaps<CR>",
		desc = " Check out keymaps",
	},
}

return M
