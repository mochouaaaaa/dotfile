return {
	-- 分屏边框颜色
	"nvim-zh/colorful-winsep.nvim",
	event = "WinNew",
	config = function()
		get_hi = vim.api.nvim_get_hl(0, { name = "Identifier" })
		require("colorful-winsep").setup({
			highlight = { fg = get_hi.fg, bg = get_hi.bg },
			excluded_ft = {
				"packer",
				"TelescopePrompt",
				"mason",
				"NvimTree",
			},
			border = "rounded",
			indicator_for_2wins = {
				-- only work when the total of windows is two
				position = nil, -- nil to disable or choose between "center", "start", "end" and "both"
				symbols = {
					-- the meaning of left, down ,up, right is the position of separator
					start_left = "󱞬",
					end_left = "󱞪",
					start_down = "󱞾",
					end_down = "󱟀",
					start_up = "󱞢",
					end_up = "󱞤",
					start_right = "󱞨",
					end_right = "󱞦",
				},
			},
		})
	end,
}
