local Util = require("lazyvim.util")
local extr_args = require("plugins.configs.fzf").extr_args

return {
	{
		"/",
		Util.telescope("current_buffer_fuzzy_find"),
	},
	{
		"<leader>fg",
		"<Cmd>Telescope git_files<CR>",
		desc = "[]Search Git File",
	},
	{
		"<D-S-f>",
		Util.telescope("live_grep", { additional_args = extr_args }),
		desc = "Grep (root dir)",
	},
	{
		"<D-f>",
		function()
			Util.telescope(
				"find_files",
				{ find_command = { "rg", "--color=never", "--smart-case", "--files", unpack(extr_args) } }
			)()
		end,
		desc = ".* Search files cucurrent directory",
	},
	{
		"<leader>fs",
		"<Cmd>Telescope spell_suggest<CR>",
		desc = "益spell suggestions about cursor word",
	},
	{
		"<leader>fb",
		function() require("telescope.builtin").buffers { sort_mru = true, sort_lastused = true } end,
		desc = "find buffers",
	},
	{
		"<leader>fk",
		"<Cmd>Telescope keymaps<CR>",
		desc = " Check out keymaps[S-C-/]",
	},
}
