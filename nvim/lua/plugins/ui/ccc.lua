local M = {
	"uga-rosa/ccc.nvim",
	cmd = {
		"CccConvert",
	},
	ft = { "css", "html" },
}

function M.keys()
	return {
		{ "<leader>h", group = "CCC" },
		{ "<leader>hl", "<Cmd>CccHighlighterToggle<CR>", desc = "Buffer Color highlight" },
		{ "<leader>hp", "<Cmd>CccPick<CR>", desc = "Color Picker" },
	}
end

function M.config(plugin)
	local ccc = require("ccc")
	local mapping = ccc.mapping
	ccc.setup({
		highlighter = {
			auto_enable = true,
			filetypes = plugin.ft,
		},
		mappings = {
			j = mapping.decrease1,
			h = mapping.toggle_input_mode,
			i = "o",
			["<q>"] = mapping.quit,
		},
	})
end

return M
