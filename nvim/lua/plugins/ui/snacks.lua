return {
	"snacks.nvim",
	opts = function()
		return {
			animate = {
				duration = 20,
				fps = 60,
			},
			bigfile = { enabled = true },
			dashboard = { enabled = true },
			explorer = { enabled = false },
			notifier = { enabled = true },
			-- indent = { enabled = true },
			input = { enabled = true },
			picker = {
				enabled = true,
				win = {
					input = {
						keys = {
							["<D-j>"] = { "list_down", mode = { "i", "n" } },
							["<D-k>"] = { "list_up", mode = { "i", "n" } },
						},
					},
				},
			},
			quickfile = { enabled = true },
			scope = { enabled = true },
			-- scroll = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			image = { enabled = true },
		}
	end,
	keys = function()
		return {
			-- {
			-- 	"<leader>fn",
			-- 	function()
			-- 		if Snacks.config.picker and Snacks.config.picker.enabled then
			-- 			Snacks.picker.notifications()
			-- 		else
			-- 			Snacks.notifier.show_history()
			-- 		end
			-- 	end,
			-- 	desc = "Notification History",
			-- },
		}
	end,
}
