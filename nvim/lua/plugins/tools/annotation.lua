local util = require("util.keymap")

return {
	{
		"nvim-mini/mini.comment",
		opts = {
			mappings = {
				comment = util.platform_key.cmd("/"),
				comment_line = util.platform_key.cmd("/"),
				comment_visual = util.platform_key.cmd("/"),
				textobject = util.platform_key.cmd("/"),
			},
		},
	},
}
