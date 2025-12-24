return {
	"rebelot/heirline.nvim",
	opts = function(_, opts)
		local lib = require("heirline-components.all")

		local config = {
			statuscolumn = { -- UI left column
				init = function(self)
					self.bufnr = vim.api.nvim_get_current_buf()
				end,
				lib.component.foldcolumn(),
				lib.component.numbercolumn(),
				lib.component.signcolumn(),
			} or nil,
		}

		return vim.tbl_deep_extend("force", opts, config)
	end,
}
