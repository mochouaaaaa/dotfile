local M = {}

local global_overrides = function(colors)
	local result = {

		Search = {
			link = "IncSearch",
		},
		IncSearch = {
			bg = colors.sky,
		},

		Identifier = {
			fg = colors.blue,
			-- bg = colors.base, --关键字例如go的make,len,panic
		},

		NormalFloat = {
			link = "Normal",
			-- bg = colors.base,
		},
		TermCursor = {
			link = "Cursor",
		},
		CursorIM = {
			link = "Cursor",
		},

		-- status line
		StatusLine = {
			bg = "NONE",
		},
		StatusLineNC = {
			bg = "NONE",
		},

		YaziBufferHoveredInSameDirectory = {
			bg = colors.base,
		},
		YaziBufferHovered = {
			bg = colors.base,
		},

		------ FZF
		-- FzfLuaBackdrop = {
		-- 	bg = colors.base,
		-- },

		FzfLuaBorder = {
			link = "Normal",
		},
		FzfLuaFzfBorder = {
			fg = colors.base,
		},

		NavicSeparator = {
			link = "@keyword",
		},
		-- ["@lsp.type.variable"] = {
		-- 	fg = "#f4b085",
		-- },
		["@constant.builtin"] = {
			fg = colors.blue,
			italic = true,
		},
		["@lsp.type.property"] = {
			fg = colors.peach,
		},

		-- ["@lsp.type.enum"] = {
		-- 	fg = "#94e2d5",
		-- },
		-- ["@lsp.typemod.method.defaultLibrary"] = {
		-- 	fg = "#94e2d5",
		-- },

		["@keyword.return"] = {
			italic = true,
		},

		-- ["@lsp.type.enumMember"] = {
		-- 	link = "enumMember",
		-- },

		MiniIndentscopeSymbol = {
			link = "MoreMsg",
		},

		Cursor = {
			bg = colors.base,
		},
		FloatBorder = {
			bg = "NONE",
		},

		-- LSP
		Pmenu = {
			bg = "NONE",
		},
		BlinkCmpMenu = {
			bg = "NONE",
		},
		LspFloating = {
			bg = "NONE",
		},
		CmpItemAbbrMatch = {
			bold = true,
		},
		CmpItemAbbr = {
			fg = colors.sapphire,
		},
		CmpItemMenu = {
			fg = colors.blue,
		},
		CmpItemAbbrMatchFuzzy = {
			link = "CmpItemAbbrMatch",
		},
	}

	return result
end

M.all = function(colors)
	return global_overrides(colors)
end

M.setup = function(color_overrides)
	require("catppuccin").setup({
		compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
		flavour = "auto",
		background = { -- :h background
			light = "latte",
			dark = "mocha",
		},
		color_overrides = color_overrides or {},
		highlight_overrides = {
			all = function(colors)
				return global_overrides(colors)
			end,
		},
		transparent_background = not vim.g.neovide_enabled,
		term_colors = true,
		auto_integrations = true,
		-- default_integrations = false,
		integrations = {
			blink_cmp = {
				style = "bordered",
			},
			blink_indent = true,
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
	})
end

return M
