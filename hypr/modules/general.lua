hl.config {
	general = {
		layout = "scrolling", -- "dwindle"
		-- layout = "monocle",

		allow_tearing = false, -- Allows `immediate` window rule to work

		gaps_workspaces = 8,
		gaps_in = 3,
		gaps_out = 3,
		border_size = 0,

		col = {
			active_border = "0x00000000",
			inactive_border = "0x00000000",
		},
	},

	dwindle = {
		preserve_split = true,
		smart_split = false,
		smart_resizing = true,
	},

	scrolling = {
		explicit_column_widths = "0.333, 0.5, 0.667, 1.0",
		column_width = 0.51,
	},

	decoration = {
		rounding = 7,
		rounding_power = 7.0,

		blur = {
			enabled = true,
			size = 6,
			passes = 4,
			ignore_opacity = true,
			new_optimizations = true,
			special = true,
			popups = true,

			noise = 0.02,
			contrast = 1.1,
			vibrancy = 0.2,
			vibrancy_darkness = 0.3,
			xray = false,
		},
		shadow = {
			enabled = true,
			range = 30,
			render_power = 3,
			color = "rgba(00000040)",
		},
	},
}
