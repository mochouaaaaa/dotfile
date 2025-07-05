return {
	"rebelot/heirline.nvim",
	dependencies = {
		"Zeioth/heirline-components.nvim",
		dependencies = {
			"folke/zen-mode.nvim",
			"stevearc/aerial.nvim",
			"SmiteshP/nvim-navic",
		},
	},
	-- event = "UIEnter",
	opts = function()
		local util = require("util.heirline")
		local lib = require("heirline-components.all")

		return {
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
			tabline = { -- UI upper bau
				lib.component.tabline_conditional_padding(),
				lib.component.tabline_buffers(),
				lib.component.fill(),
				lib.component.tabline_tabpages(),
			},
			winbar = { -- UI breadcrumbs bar
				init = function(self)
					self.bufnr = vim.api.nvim_get_current_buf()
				end,
				fallthrough = false,
				lib.component.winbar_when_inactive(),
				{

					{
						provider = " ",
					},
					util.navic(),
					lib.component.fill(),
				},
			},
			statusline = { -- UI statusbar
				-- left
				{
					init = function()
						-- left_components_length = 4
					end,
					provider = function()
						return "   "
					end,
					hl = util.primary_highlight,
				},
				lib.component.git_branch(),
				lib.component.fill(),
				-- center
				-- util.FileIcon,
				lib.component.lsp({ lsp_progress = false }),
				lib.component.fill(),
				-- right
				-- util.LspProgress,
				{
					condition = function()
						return vim.bo.filetype == "python"
					end,
					lib.component.virtual_env(),
				},
				{
					provider = function()
						local emoji = { "🚫", "⏸️", "⌛️", "⚠️", "0️⃣ ", "✅" }
						return emoji[require("fittencode").get_current_status()]
					end,
					condition = function()
						return package.loaded.fittencode
					end,
				},
				util.SearchCount,
				util.positioning,
			},
		}
	end,
	config = function(_, opts)
		local heirline = require("heirline")
		local heirline_components = require("heirline-components.all")

		-- Setup
		heirline_components.init.subscribe_to_events()

		heirline.load_colors(heirline_components.hl.get_colors())
		heirline.setup(opts)
	end,
}
