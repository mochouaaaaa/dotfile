local catppuccin = require("catppuccin")

return {
	{
		"f-person/auto-dark-mode.nvim",
		lazy = false,
		opts = {
			set_dark_mode = function()
				vim.api.nvim_set_option_value("background", "dark", {})
				catppuccin.setup({
					flavour = "mocha",
					custom_highlights = require("plugins.ui.theme.mode").dark(),
				})

				vim.cmd.colorscheme("catppuccin")
			end,
			set_light_mode = function()
				vim.api.nvim_set_option_value("background", "light", {})
				catppuccin.setup({
					flavour = "latte",
					custom_highlights = require("plugins.ui.theme.mode").light(),
				})
				vim.cmd.colorscheme("catppuccin")
			end,
			update_interval = 3000,
			fallback = "dark",
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		build = ":CatppuccinCompile",
		opts = {
			transparent_background = not vim.g.neovide_enabled,
			term_colors = true,
			integrations = {
				blink_cmp = true,
				copilot_vim = true,
				dap = true,
				dap_ui = true,
				dashboard = true,
				flash = false,
				fzf = true,
				notifier = true,
				noice = true,
				neotree = false,
				gitsigns = true,
				markdown = true,
				render_markdown = true,
				headlines = true,
				telekasten = true,
				ts_rainbow2 = false,
				lsp_trouble = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
					},
					inlay_hints = {
						background = true,
					},
				},
				rainbow_delimiters = true,
				treesitter = true,
				treesitter_context = false,
				telescope = {
					enabled = true,
				},

				navic = { enabled = true, custom_bg = "NONE" },
				-- leap               = true,
				mason = false,
				indent_blankline = {
					enable = true,
					colored_indent_levels = true,
				},
				window_picker = true,
				which_key = true,
				symbols_outline = false,
			},
		},
	},
}
