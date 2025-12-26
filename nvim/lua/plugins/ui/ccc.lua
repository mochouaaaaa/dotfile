return {
	"uga-rosa/ccc.nvim",
	-- cmd = {
	-- 	"CccConvert",
	-- },
	config = function(plugin)
		vim.notify(plugin.ft)
		local ccc = require("ccc")
		-- local mapping = ccc.mapping
		ccc.setup({
			pickers = {
				ccc.picker.ansi_escape({
					foreground = "#cccccc",
					background = "#0c0c0c",
					black = "#0c0c0c",
					red = "#c50f1f",
					green = "#13a10e",
					yellow = "#c19c00",
					blue = "#0037da",
					magenta = "#881798",
					cyan = "#3a96dd",
					white = "#cccccc",
					bright_black = "#767676",
					bright_red = "#e74856",
					bright_green = "#16c60c",
					bright_yellow = "#f9f1a5",
					bright_blue = "#3b78ff",
					bright_magenta = "#b4009e",
					bright_cyan = "#61d6d6",
					bright_white = "#f2f2f2",
				}),
			},
			highlighter = {
				auto_enable = true,
				-- filetypes = plugin.ft,
				filetypes = { "lua", "conf", "yaml", "toml", "nix" },
			},
		})
	end,
	keys = function()
		return {
			{ "<leader>hl", "<Cmd>CccHighlighterToggle<CR>", desc = "Buffer Color highlight" },
			{ "<leader>hp", "<Cmd>CccPick<CR>", desc = "Color Picker" },
		}
	end,
}
