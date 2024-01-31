local extr_args = {
	"--hidden", -- Search hidden files that are prefixed with `.`
	"--no-ignore", -- Don’t respect .gitignore
	"-g",
	"!.git/",
	"-g",
	"!node_modules/",
	"-g",
	"!.idea/",
	"-g",
	"!pnpm-lock.yaml",
	"-g",
	"!package-lock.json",
	"-g",
	"!go.sum",
	"-g",
	"!lazy-lock.json",
	"-g",
	"!.zsh_history",
	"-g",
	"!__pycache__",
}

local Util = require("lazyvim.util")

return {
	{
		"/",
		-- You can pass additional configuration to telescope to change theme, layout, etc.
		-- require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
		-- 	winblend = 10,
		-- 	previewer = true,
		-- })
		Util.telescope("current_buffer_fuzzy_find"),
	},
	{
		"<leader>fh",
		"<Cmd>Telescope help_tags<CR>",
		desc = " Check out all tags",
	},
	{
		"<leader>fH",
		"<Cmd>Telescope highlights<CR>",
		desc = "[] Check out all highlights",
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
		-- function()
		-- 	require("telescope.builtin").find_files {
		-- 		find_command = { "rg", "--color=never", "--smart-case", "--files", unpack(extr_args) },
		-- 	}
		-- end,
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
		"<leader>fag",
		"<Cmd>Telescope treesitter<CR>",
		desc = "滑Have a look at the tags provided by 滑",
	},
	{
		"<leader>fe",
		"<Cmd>Telescope diagnostics<CR>",
		desc = " take a look",
	},
	{
		"<C-p>",
		"<cmd>lua require('telescope.builtin').commands()<cr>",
		desc = "查询所有的command命令",
	},
	{
		"<leader>fj",
		"<Cmd>Telescope jumplist<CR>",
		desc = " Get jumplist",
	},
	{
		"<leader>fk",
		"<Cmd>Telescope keymaps<CR>",
		desc = " Check out keymaps[S-C-/]",
	},
}
