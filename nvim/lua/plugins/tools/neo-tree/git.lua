return {
	"nvim-neo-tree/neo-tree.nvim",
	opts = {
		git_status = {
			window = {
				mappings = {
					["A"] = "git_add_all",
					["u"] = "git_unstage_file",
					["gU"] = "git_undo_last_commit",
					["a"] = "git_add_file",
					["r"] = "git_revert_file",
					["c"] = "git_commit",
					["p"] = "git_push",
					["C"] = "git_commit_and_push",
				},
			},
		},
	},
}
