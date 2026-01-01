return {
	"nvim-zh/colorful-winsep.nvim",
	event = { "WinLeave" },
	enabled = false,
	opts = {
		excluded_ft = { "fzf", "code-runner", "runner", "NvimTerm" },
		border = "rounded",
	},
}
