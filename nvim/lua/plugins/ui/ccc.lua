local M = {
	"uga-rosa/ccc.nvim",
	cmd = {
		"CccConvert",
	},
	ft = { "css", "html" },
}

local function init_keys()
	local wk = require("which-key")
	wk.register {
		["<leader>h"] = {
			name = "+ccc",
			l = { "<Cmd>CccHighlighterToggle<CR>", "Buffer Color highlight" },
			p = { "<Cmd>CccPick<CR>", "Color Picker" },
		},
	}
end

function M.config(plugin)
	init_keys()
	local ccc = require("ccc")
	local mapping = ccc.mapping
	ccc.setup {
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
	}
end

return M
