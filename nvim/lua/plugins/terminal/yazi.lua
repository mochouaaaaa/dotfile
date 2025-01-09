local _key = require("util.keymap")

local M = {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	config = function()
		vim.env.PATH = os.getenv("PATH")
		vim.keymap.set("n", _key.platform_key.cmd .. "-r>", function()
			require("yazi").yazi({
				open_for_directories = false,
				-- log_level = vim.log.levels.DEBUG,
			})
		end)
	end,
}

return M
