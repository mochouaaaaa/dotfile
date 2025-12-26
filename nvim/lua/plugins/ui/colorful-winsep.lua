return {
	"nvim-zh/colorful-winsep.nvim",
	event = "WinNew",
	opts = {
		excluded_ft = { "fzf", "code-runner", "runner", "NvimTerm" },
		border = "rounded",
	},
}
