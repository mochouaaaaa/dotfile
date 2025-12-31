return {
	"nvim-zh/colorful-winsep.nvim",
	event = { "WinLeave" },
	opts = {
		excluded_ft = { "fzf", "code-runner", "runner", "NvimTerm" },
		border = "rounded",
	},
}
