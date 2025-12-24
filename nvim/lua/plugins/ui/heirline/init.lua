return {
	{ import = "plugins.ui.heirline" },
	{
		"rebelot/heirline.nvim",
		dependencies = { "zeioth/heirline-components.nvim" },
		opts = function(_, opts)
			local lib = require("heirline-components.all")

			local config = {
				opts = {
					disable_winbar_cb = function(args) -- We do this to avoid showing it on the greeter.
						local is_disabled = not require("heirline-components.buffer").is_valid(args.buf)
							or lib.condition.buffer_matches({
								buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
								filetype = { "NvimTree", "neo%-tree", "dashboard", "Outline", "aerial" },
							}, args.buf)
						return is_disabled
					end,
				},
			}

			return vim.tbl_deep_extend("force", opts, config)
		end,
		config = function(_, opts)
			vim.opt.showtabline = 2

			local heirline = require("heirline")
			local heirline_components = require("heirline-components.all")

			-- Setup
			heirline_components.init.subscribe_to_events()
			heirline.load_colors(heirline_components.hl.get_colors())
			heirline.setup(opts)
		end,
	},
}
