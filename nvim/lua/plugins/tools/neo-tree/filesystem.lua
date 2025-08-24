return {
	"nvim-neo-tree/neo-tree.nvim",
	opts = {
		filesystem = {
			hijack_netrw_behavior = "open_current",
			event_handlers = {
				{
					event = "neo_tree_buffer_enter",
					handler = function(_)
						vim.opt_local.signcolumn = "auto"
					end,
				},
				{
					event = "after_render",
					handler = function(state)
						if state.current_position == "left" or state.current_position == "right" then
							vim.api.nvim_win_call(state.winid, function()
								local str = require("neo-tree.ui.selector").get()
								if str then
									_G.__cached_neo_tree_selector = str
								end
							end)
						end
					end,
				},
			},
		},
	},
}
