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

return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	lazy = false,
	enabled = true,
	opts = {
		compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
		flavour = "auto",
		background = { -- :h background
			light = "latte",
			dark = "mocha",
		},
		color_overrides = {},
		float = {
			transparent = true, -- enable transparent floating windows
			solid = false, -- use solid styling for floating windows, see |winborder|
		},
		highlight_overrides = {
			all = function(colors)
				return global_overrides(colors)
			end,
		},
		transparent_background = not vim.g.neovide_enabled,
		term_colors = true,
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		-- vim.cmd.colorscheme("catppuccin-nvim")
	end,
}
