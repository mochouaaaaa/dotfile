return {
	"nvim-neo-tree/neo-tree.nvim",
	opts = {
		window = {
			mapping_options = {
				noremap = true,
				nowait = true,
			},
			mappings = {
				["<space>"] = "none",
				["<cr>"] = "open",
				["<tab>"] = "open",
				["?"] = "show_help",
				["l"] = "none",
				["h"] = "none",
				["_"] = "open_split",
				["|"] = "open_vsplit",
			},
		},
	},
}
