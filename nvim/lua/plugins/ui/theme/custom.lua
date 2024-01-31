return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	build = ":CatppuccinCompile",
	enabled = true,
	config = function()
		require("catppuccin").setup {
			-- compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
			flavour = "mocha",
			transparent_background = not vim.g.neovide,
			term_colors = true,
			custom_highlights = require("plugins.ui.theme.override"),
			dim_inactive = {
				enabled = false,
				shade = "dark",
				percentage = 0.15,
			},
			integrations = {
				cmp = true,
				dashboard = true,
				flash = true,
				notify = true,
				noice = true,
				neotree = false,
				gitsigns = true,
				markdown = true,
				headlines = true,
				telekasten = true,
				ts_rainbow2 = true,
				lsp_trouble = true,
				lsp_saga = false,
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
				treesitter_context = true,
				telescope = {
					enabled = true,
				},
				-- dropbar = { enabled = true, color_mode = true },

				navic = { enabled = true },
				-- leap               = true,
				mason = true,
				indent_blankline = {
					enable = true,
					colored_indent_levels = true,
				},
				window_picker = true,
				which_key = true,
			},
		}
		vim.cmd.colorscheme("catppuccin")
	end,
}
