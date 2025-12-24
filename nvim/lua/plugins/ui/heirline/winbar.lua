return {
	"rebelot/heirline.nvim",
	dependencies = {},
	opts = function(_, opts)
		local lib = require("heirline-components.all")
		local navic = require("nvim-navic")

		local config = {
			winbar = { -- UI breadcrumbs bar
				init = function(self)
					self.bufnr = vim.api.nvim_get_current_buf()
				end,
				fallthrough = false,
				lib.component.winbar_when_inactive(),

				{
					{ provider = "  " },
					{
						condition = function()
							return navic.is_available()
						end,
						provider = function()
							return navic.get_location({ highlight = true })
						end,
						update = "CursorMoved",
					},
				},
			},
		}

		return vim.tbl_deep_extend("force", opts, config)
	end,
}
