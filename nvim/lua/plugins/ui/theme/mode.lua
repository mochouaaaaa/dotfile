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
			bg = colors.base,
		},

		StatusLine = { bg = colors.base }, -- status line

		NormalFloat = {
			link = "Normal",
			bg = colors.base,
		},
		TermCursor = {
			link = "Cursor",
		},
		CursorIM = {
			link = "Cursor",
		},

		YaziBufferHoveredInSameDirectory = {
			bg = colors.base,
		},
		YaziBufferHovered = {
			bg = colors.base,
		},
		FzfLuaBackdrop = {
			bg = colors.base,
		},

		NavicSeparator = {
			link = "@keyword",
		},
		["@lsp.type.variable"] = {
			fg = "#f4b085",
		},
		["@constant.builtin"] = {
			fg = colors.blue,
			italic = true,
		},
		["@lsp.type.property"] = {
			fg = colors.peach,
		},
		["@lsp.type.enum"] = {
			fg = "#94e2d5",
		},
		["@lsp.typemod.method.defaultLibrary"] = {
			fg = "#94e2d5",
		},
		["@keyword.return"] = {
			italic = true,
		},
		Pmenu = {
			bg = colors.base,
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

		-- ['@lsp.type.enumMember'] = {
		--     link = 'enumMember',
		-- },

		CmpItemAbbrMatch = {
			bold = true,
		},

		MiniIndentscopeSymbol = {
			link = "MoreMsg",
		},
		Normal = {
			bg = colors.base,
		},
		Cursor = {
			bg = colors.base,
		},
		FloatBorder = {
			bg = colors.base,
		},
	}

	return result
end

M.dark = function()
	local theme = require("plugins.ui.theme.dark")
	local override_dark = vim.tbl_deep_extend("force", theme.highlights, global_overrides(theme.colors))
	return override_dark
end

M.light = function()
	local theme = require("plugins.ui.theme.light")
	local override_light = vim.tbl_deep_extend("force", theme.highlights, global_overrides(theme.colors))
	return override_light
end

return M
