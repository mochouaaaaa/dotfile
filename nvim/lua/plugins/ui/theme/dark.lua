local color_overrides = {
	dim_gray = "#2d4f67",
	dark = "#0c0e0f",
	dim_blue = "#6791c9",
	disabled = "#707880",
	dim = "#282832",
	gray = "#8a8e97",
	rosewater = "#f5e0dc",
	flamingo = "#f2cdcd",
	pink = "#f5c2e7",
	mauve = "#cba6f7",
	red = "#f38ba8",
	dark_red = "#f55385",
	maroon = "#eba0ac",
	white = "#ffffff",
	-- peach        = '#fab387',
	peach = "#e5c078",
	yellow = "#f9e2af",
	green = "#a6e3a1",
	light_green = "#89e051",
	custom = "#69bbae",
	teal = "#94e2d5",
	sky = "#89dceb",
	sapphire = "#74c7ec",
	blue = "#89b4fa",
	light_blue = "#599eff",
	lavender = "#b4befe",
	base = "#1e1e2e",
	mantle = "#181825",
	purple = "#7c3aed",
	light_purple = "#c61ad9",
}

local highlight_overrides = function(colors)
	local result = {
		Visual = {
			fg = colors.sapphire,
			bg = colors.dim,
		},
		PmenuSel = {
			bold = true,
			fg = colors.mantle,
			bg = colors.light_green,
		},
		IncSearch = {
			fg = colors.mantle,
			-- bg = colors.sky,
		},
		MoreMsg = {
			fg = colors.light_blue,
			bold = true,
		},
		Cursor = {
			bg = colors.light_blue,
		},
		--
		-- CursorLine = {
		-- 	bg = c.base,
		-- },

		SagaBorder = {
			fg = colors.purple,
			bg = "NONE",
		},
		CodeActionText = {
			fg = colors.light_blue,
		},
		-- ['@property']               = {

		IlluminatedWordText = {
			bg = colors.dim_gray,
		},
		IlluminatedWordRead = {
			link = "IlluminatedWordText",
		},
		IlluminatedWordWrite = {
			link = "IlluminatedWordText",
		},
		["@keyword.return"] = {
			fg = colors.dark_red,
		},
		-- ['@lsp.type.enumMember'] = {
		--     link = 'enumMember',
		-- },

		CmpItemAbbrMatch = {
			fg = colors.purple,
		},

		-- BufferLineBufferSelected = {
		-- 	fg = colors.sapphire,
		-- },

		MatchParen = {
			fg = "#FFD700",
			bg = "#505050",

			-- bg = c.purple,
			-- fg = c.light_green,
			bold = true,
		},

		IndentBlanklineContextChar = {
			fg = "#89e051",
		},
		IndentBlanklineContextStart = {
			underline = true,
			sp = "#89e051",
		},

		FloatBorder = {
			fg = "#89B4FA",
			bg = "NONE",
		},
		FloatTitle = {
			fg = "#938aa9",
			bg = "NONE",
		},
	}

	if vim.g.neovide then
		result.Normal = {
			fg = "#89b4fa",
			bg = "#1e1e2e",
		}
	end

	return result
end

return { colors = color_overrides, highlights = highlight_overrides(color_overrides) }
