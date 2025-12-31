return {
	"nvim-neo-tree/neo-tree.nvim",
	opts = {
		buffers = {
			follow_current_file = { enabled = true },
			group_empty_dirs = true,
			show_unloaded = false, -- 不显示尚未加载的 buffer
			window = {
				position = "float",
			},
			bind_to_cwd = true,
			terminals_first = false,
		},
	},
}
