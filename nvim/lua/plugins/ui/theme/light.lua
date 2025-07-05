local color_overrides = {
	mauve = "#6A67B4",
	pink = "#6A67B4",
	flamingo = "#A352A0",
	rosewater = "#A352A0",
	red = "#C34165",
	maroon = "#C34165",
	yellow = "#8A7400",
	peach = "#AC591C",
	green = "#288043",
	teal = "#007E7D",
	sky = "#007E7D",
	sapphire = "#007E7D",
	blue = "#1675AB",
	lavender = "#1675AB",
	text = "#706F7A",
	subtext1 = "#757480",
	subtext0 = "#757480",
	overlay2 = "#797985",
	overlay1 = "#7E7D8A",
	overlay0 = "#84828F",
	surface2 = "#9C8282",
	surface1 = "#EBDFD3",
	surface0 = "#EBDFD3",
	base = "#eff1f5",
	mantle = "#FCF9F5",
	crust = "#FCF9F5",
}

-- parameter: colors color_overrides
local highlight_overrides = function(colors)
	return {
		-- surface0 and 1 is used as a background color most of the time,
		-- but also as a foreground color in some cases. This makes it
		-- impossible to ensure contrast in all cases.
		-- For this reason, we replace all surface foreground colors with
		-- other surface colors to increase contrast.
		-- (surface2 is a rare color which is exclusively used as a
		-- foreground color)
		--
		-- surface0:
		SnacksIndent = { fg = colors.surface1 },
		IblIndent = { fg = colors.surface1 },

		-- surface1:
		SignColumn = { fg = colors.surface2 }, -- column where |signs| are displayed
		SignColumnSB = { fg = colors.surface2 }, -- column where |signs| are displayed

		LineNr = { fg = colors.surface2 }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' o…
		TreesitterContextLineNumber = { fg = colors.surface2 },
		CursorLineNr = { fg = colors.blue }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.

		DapUIUnavailable = { fg = colors.surface2 },

		GitSignsCurrentLineBlame = { fg = colors.surface2 },

		-- More contrast menus:
		Pmenu = { fg = colors.overlay2 }, -- Popup menu: normal item.
		PmenuSel = { bg = colors.surface1, style = { "bold" } }, -- Popup menu: selected item.

		-- More contrast for window separator:
		WinSeparator = { fg = colors.surface2 }, -- Separator between windows.

		["@keyword.return"] = {
			fg = colors.red,
		},
	}
end

return { colors = color_overrides, highlights = highlight_overrides(color_overrides) }
