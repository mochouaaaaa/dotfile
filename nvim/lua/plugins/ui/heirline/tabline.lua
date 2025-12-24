return {
	"rebelot/heirline.nvim",
	opts = function(_, opts)
		local lib = require("heirline-components.all")

		local config = {
			tabline = { -- UI upper bar
				-- lib.component.tabline_conditional_padding({}),
				lib.component.tabline_conditional_padding(),
				lib.component.tabline_buffers({
					close_button = false,
					-- surround = {
					-- 	separator = { "⎡", "⎦" },
					-- 	color = function(self)
					-- 		if vim.api.nvim_get_current_buf() == self.bufnr then
					-- 			return lib.hl.get_attributes("BufferCurrent")
					-- 		end
					-- 		return lib.hl.get_attributes(self.tab_type)
					-- 	end,
					-- },
				}),
				-- lib.component.fill(),
				lib.component.tabline_tabpages(),
			},
		}

		local r = vim.tbl_deep_extend("force", opts, config)

		return r
	end,
}
