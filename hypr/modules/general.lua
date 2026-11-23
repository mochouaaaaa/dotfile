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
			-- size = 4,
			-- passes = 3,
			-- ignore_opacity = false,
			-- new_optimizations = true,
			special = true,
			popups = true,
			-- xray = false,

			-- noise = 0.02,
			-- contrast = 1.1,
			-- vibrancy = 0.2,
			-- vibrancy_darkness = 0.3,

			-- 模糊强度
			size = 4,
			passes = 3,

			-- 透明度
			ignore_opacity = true,

			-- 性能
			new_optimizations = true,
			xray = false,

			-- 玻璃质感
			brightness = 0.78,
			contrast = 1.15,
			noise = 0.015,

			-- 色彩保留
			vibrancy = 0.18,
			vibrancy_darkness = 0.25,
		},
		shadow = {
			enabled = true,
			range = 30,
			render_power = 3,
			color = "rgba(00000040)",
		},
	},
}
