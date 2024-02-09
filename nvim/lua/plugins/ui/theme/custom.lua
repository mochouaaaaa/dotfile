return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	build = ":CatppuccinCompile",
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
				dap=true,
				dap_ui = true,
				dashboard = true,
				flash = true,
				notify = false,
				noice = false,
				neotree = false,
				gitsigns = true,
				markdown = true,
				headlines = true,
				telekasten = true,
				ts_rainbow2 = false,
				lsp_trouble = false,
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

				navic = { enabled = false
			 },
				-- leap               = true,
				mason = false,
				indent_blankline = {
					enable = true,
					colored_indent_levels = true,
				},
				window_picker = false,
				which_key = false,
				symbols_outline = false
			},
		}
		vim.cmd.colorscheme("catppuccin")
	end,
}
