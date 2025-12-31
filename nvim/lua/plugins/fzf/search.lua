local HEADER = "`<alt-i>` use .gitignore"

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
			prompt = vim.g.icons.Telescope.Prefix,
			header = HEADER,
			input_prompt = "Grep For❯ ",
			git_icons = true,
		},
	},
}
