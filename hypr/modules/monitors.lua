-- Primary 4K display. Keep its explicit mode and color settings.
hl.monitor {
	output = "DP-1",
	mode = "3840x2160@60",
	position = "0x0",
	scale = 1.5,
	bitdepth = 10,
	cm = "auto",
}

-- Any additional display uses its preferred mode and is placed automatically.
hl.monitor {
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1,
}

hl.config {
	xwayland = {
		force_zero_scaling = true,
	},
}
